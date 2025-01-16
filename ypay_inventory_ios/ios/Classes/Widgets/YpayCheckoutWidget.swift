import Flutter
import YandexPaySDK

public class YpayCheckoutWidgetFactory : NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }

    public init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {
        let methodChannel = FlutterMethodChannel(name: "com.yandex.pay.flutter_channel/ypay-info-widget-view_" +  "\(viewId)", binaryMessenger: messenger)

        return YpayCheckoutWidgetView(frame, viewId: viewId, methodChannel: methodChannel, args: args)!
    }
}

public class YpayCheckoutWidgetView : NSObject, FlutterPlatformView {
    let frame: CGRect
    let viewId: Int64
    let methodChannel: FlutterMethodChannel
    var args: [String: Any]
    var viewController: YpayCheckoutWidgetUIViewController?
    
    init?(_ frame: CGRect, viewId: Int64, methodChannel: FlutterMethodChannel, args: Any?) {
        self.frame = frame
        self.viewId = viewId
        self.methodChannel = methodChannel
        
        self.args = [:]
        super.init()
        
        self.updateArgs(args: args, shouldRebuild: false)
        
        self.viewController = YpayCheckoutWidgetUIViewController(args: self.args, channel: methodChannel, viewId: viewId)

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
        let selfTheme = (self.args["appearance"] as? YPCheckoutWidgetModel.Appearance)?.theme ?? YPTheme.system
        let selfStyle = self.args["style"] as? YPCheckoutWidgetModel.Style
        
        let amountArg = amount == nil ? selfAmount : Decimal(amount!)
        let themeArg = theme == nil ? selfTheme : YPTheme(rawValue: theme!)
        
        let styleArg: YPCheckoutWidgetModel.Style
        
        if (style == nil) {
            styleArg = selfStyle ?? YPCheckoutWidgetModel.Style.fullBox
        } else if (style!.count == 2 || style!.isEmpty) {
            styleArg = YPCheckoutWidgetModel.Style.fullBox
        } else if (style![0] == "cashback") {
            styleArg = YPCheckoutWidgetModel.Style.cashbackOnly
        } else {
            styleArg = YPCheckoutWidgetModel.Style.splitOnly
        }
    
        let appearanceArg = YPCheckoutWidgetModel.Appearance(theme: themeArg!)
        
        self.args = [
            "amount": amountArg!,
            "style": styleArg,
            "appearance": appearanceArg
        ]
        
        if (shouldRebuild) {
            self.viewController!.updateView(args: self.args)
        }
    }
    
    public func view() -> UIView {
        return self.viewController!.view
    }
}

class YpayCheckoutWidgetUIViewController : UIViewController, YPPresentationContextProviding {
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
        
        let newSubview = YandexPaySDKApi.instance.createCheckoutWidgetView(model: YPCheckoutWidgetModel(amount: args["amount"] as! Decimal, style: args["style"] as! YPCheckoutWidgetModel.Style, appearance: args["appearance"] as! YPCheckoutWidgetModel.Appearance)) as UIView
        
        widgetView!.removeFromSuperview()
        
        updateSize(newView: newSubview)
        
        widgetView = newSubview
        
        view.layoutIfNeeded()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widgetView = YandexPaySDKApi.instance.createCheckoutWidgetView(model: YPCheckoutWidgetModel(amount: args["amount"] as! Decimal, style: args["style"] as! YPCheckoutWidgetModel.Style, appearance: args["appearance"] as! YPCheckoutWidgetModel.Appearance))
        
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
        
        let widgetSubview = self.view.subviews.first!
        let widgetSubviewSize = widgetSubview.frame.size
        print("CHECKOUT WIDGET Размер: \(widgetSubviewSize)")
        
        channel.invokeMethod("onSizeChanged", arguments: [
            "id": viewId,
            "viewType": "ypay-info-widget-view",
            "width": widgetSubviewSize.width,
            "height": widgetSubviewSize.height
            ]
        )
    }
}
