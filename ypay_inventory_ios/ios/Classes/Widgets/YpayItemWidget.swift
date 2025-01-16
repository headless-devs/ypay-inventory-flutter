import Flutter
import YandexPaySDK

public class YpayItemWidgetFactory : NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }

    public init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {
        let methodChannel = FlutterMethodChannel(name: "com.yandex.pay.flutter_channel/ypay-simple-widget-view_" +  "\(viewId)", binaryMessenger: messenger)
        return YpayItemWidgetView(frame, viewId: viewId, methodChannel: methodChannel, args: args)!
    }
}

public class YpayItemWidgetView : NSObject, FlutterPlatformView {
    let frame: CGRect
    let viewId: Int64
    let methodChannel: FlutterMethodChannel
    
    var args: [String: Any]
    var viewController: YpayItemWidgetUIViewController?
    
    init?(_ frame: CGRect, viewId: Int64, methodChannel: FlutterMethodChannel, args: Any?) {
        self.frame = frame
        self.viewId = viewId
        self.methodChannel = methodChannel
        self.args = [:]
        super.init()
        
        self.updateArgs(args: args, shouldRebuild: false)
        
        self.viewController = YpayItemWidgetUIViewController(args: self.args, channel: methodChannel, viewId: viewId)

        methodChannel.setMethodCallHandler { (call, result) in
            self.handleMethodCall(call: call, result: result)
        }
    }
    
    private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
            switch call.method {
            case "updateViewOptions": updateArgs(args: call.arguments, shouldRebuild: true)
                result(nil)
            case "waitForInit":
                result("success")
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    
    private func updateArgs(args: Any!, shouldRebuild: Bool) {
        let callArgs = args as? [String: Any] ?? [:]
        let amount = callArgs["sum"] as? Double
        let theme = callArgs["theme"] as? String
        let isTransparent = callArgs["style"] as? String
        let style = callArgs["types"] as? [String]
        
        let selfAmount = self.args["amount"]
        let selfTheme = (self.args["appearance"] as? YPItemWidgetModel.Appearance)?.theme
        let selfIsTransparent = (self.args["appearance"] as? YPItemWidgetModel.Appearance)?.isTransparent ?? false
        let selfStyle = self.args["style"] as? YPItemWidgetModel.Style
        
        let amountArg = amount == nil ? selfAmount : Decimal(amount!)
        let themeArg = theme == nil ? selfTheme : YPTheme(rawValue: theme!)
        
        let styleArg: YPItemWidgetModel.Style
        
        if (style == nil) {
            styleArg = selfStyle ?? YPItemWidgetModel.Style.fullSize
        } else if (style!.count == 2 || style!.isEmpty) {
            styleArg = YPItemWidgetModel.Style.fullSize
        } else {
            styleArg = YPItemWidgetModel.Style(rawValue: style![0])!
        }
        
        let appearanceArg = YPItemWidgetModel.Appearance(theme: themeArg!, isTransparent: isTransparent == nil ? selfIsTransparent : isTransparent == "transparent")
        
        self.args = [
            "amount": amountArg!,
            "style": styleArg,
            "appearance": appearanceArg,
        ]
        
        if (shouldRebuild) {
            self.viewController!.updateView(args: self.args)
        }
    }
    
    public func view() -> UIView {
        return self.viewController!.view
    }
}

class YpayItemWidgetUIViewController : UIViewController, YPPresentationContextProviding {
    func anchorForPresentation() -> YandexPaySDK.YPPresentationContext {
        .keyWindow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var args: [String: Any]!
    let channel: FlutterMethodChannel
    let viewId: Int64
    
    var widgetView: UIView?
    
    init(args: [String: Any], channel: FlutterMethodChannel, viewId: Int64) {
        self.channel = channel
        self.args = args
        self.viewId = viewId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    func updateView(args: [String: Any]) {
        self.args.removeAll()
        self.args = args
        
        let newSubview = YandexPaySDKApi.instance.createItemWidgetView(
            model: YPItemWidgetModel(amount: args["amount"] as! Decimal, style: args["style"] as! YPItemWidgetModel.Style, appearance: args["appearance"] as! YPItemWidgetModel.Appearance), presentationContextProvider: self
        ) as UIView
        
        widgetView!.removeFromSuperview()
        
        updateSize(newView: newSubview)
        
        widgetView = newSubview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widgetView = YandexPaySDKApi.instance.createItemWidgetView(
            model: YPItemWidgetModel(amount: args["amount"] as! Decimal, style: args["style"] as! YPItemWidgetModel.Style, appearance: args["appearance"] as! YPItemWidgetModel.Appearance), presentationContextProvider: self
        )
        
        updateSize(newView: widgetView!)
        
        view.layoutIfNeeded()
    }
    
    private func updateSize(newView: UIView) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(newView)

        NSLayoutConstraint.activate([
            newView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            newView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        let width = newView.bounds.width
        let targetSize = CGSize(width: self.view.bounds.width, height: UIView.layoutFittingCompressedSize.height)

        let fittingSize = newView.sizeThatFits(targetSize)

        newView.frame = CGRect(x: 0, y: 0, width: width, height: fittingSize.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let widgetView = self.view.subviews.first!
        let widgetViewSize = widgetView.frame.size
        print("ITEM WIDGET Размер: \(widgetViewSize)")
        
        channel.invokeMethod("onSizeChanged", arguments: [
            "id": viewId,
            "viewType": "ypay-simple-widget-view",
            "width": widgetViewSize.width,
            "height": widgetViewSize.height
            ]
        )
    }
}
