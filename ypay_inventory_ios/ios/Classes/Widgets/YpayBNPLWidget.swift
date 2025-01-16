import Flutter
import YandexPaySDK
import SwiftUI

public class YpayBNPLWidgetFactory : NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var methodChannel: FlutterMethodChannel

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }

    public init(messenger: FlutterBinaryMessenger, methodChannel: FlutterMethodChannel) {
        self.messenger = messenger
        self.methodChannel = methodChannel
        super.init()
    }

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {
        return YpayBNPLWidgetView(frame, viewId: viewId, methodChannel: methodChannel, messenger: messenger, args: args)!
    }
}

public class YpayBNPLWidgetView : NSObject, FlutterPlatformView {
    let frame: CGRect
    let viewId: Int64
    let methodChannel: FlutterMethodChannel
    let messenger: FlutterBinaryMessenger
    var args: [String: Any]
    var viewController: YpayBNPLWidgetUIViewController?

    init?(_ frame: CGRect, viewId: Int64, methodChannel: FlutterMethodChannel,messenger: FlutterBinaryMessenger, args: Any?) {
        self.frame = frame
        self.viewId = viewId
        self.methodChannel = methodChannel
        self.messenger = messenger
        self.args = [:]
        super.init()

        self.updateArgs(args: args, shouldRebuild: false)

        self.viewController = YpayBNPLWidgetUIViewController(args: self.args, channel: methodChannel, viewId: viewId)

        let channel = FlutterMethodChannel(name: "com.yandex.pay.flutter_channel/ypay-bnpl-preview-widget-view_" +  "\(viewId)", binaryMessenger: messenger)

        channel.setMethodCallHandler { (call, result) in
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
        let header = callArgs["header"] as? String
        let theme = callArgs["theme"] as? String
        let radius = callArgs["radius"] as? Double
        let hasOutline = callArgs["hasOutline"] as? Bool
        let hasPadding = callArgs["hasPadding"] as? Bool
        let hasCheckoutButton = callArgs["hasCheckoutButton"] as? Bool
        let size = callArgs["size"] as? String
        let background = callArgs["background"] as? String
        let backgroundColor = callArgs["backgroundColor"] as? String
        let withHeaderClickListener = callArgs["withHeaderClickListener"] as? Bool
        
        let selfAmount = self.args["amount"] as? Decimal
        let selfAppearance = self.args["appearance"] as? YPBnplPreviewWidgetModel.Appearance
        
        let amountArg = amount == nil ? selfAmount : Decimal(amount!)

        let backgroundColorArg: YPBnplPreviewWidgetModel.Appearance.Background
        
        if (background == nil && backgroundColor == nil) {
            backgroundColorArg = selfAppearance?.background ?? YPBnplPreviewWidgetModel.Appearance.Background.default
        } else if (backgroundColor != nil) {
            let color = SwiftUI.Color(UIColor(argb: backgroundColor!))
            backgroundColorArg = YPBnplPreviewWidgetModel.Appearance.Background.custom(color)
        } else if (background != nil) {
            switch (background) {
            case "standard": backgroundColorArg = YPBnplPreviewWidgetModel.Appearance.Background.default
            case "transparent": backgroundColorArg = YPBnplPreviewWidgetModel.Appearance.Background.transparent
            default: backgroundColorArg = YPBnplPreviewWidgetModel.Appearance.Background.default
            }
        } else {
            backgroundColorArg = YPBnplPreviewWidgetModel.Appearance.Background.default
        }
        
        let selfHeader = self.args["header"] as? YPBnplPreviewWidgetModel.HeaderStyle
        let selfWithHeaderClickListener = selfHeader == YPBnplPreviewWidgetModel.HeaderStyle.standardWithCustomAction
        
        let headerArg = header == nil ? selfHeader : YPBnplPreviewWidgetModel.HeaderStyle(rawValue: (withHeaderClickListener ?? selfWithHeaderClickListener) ? "standardWithCustomAction" : header!)
        
        let themeArg = theme == nil ? selfAppearance?.theme : YPTheme(rawValue: theme!)
        
        let radiusArg = radius == nil ? selfAppearance?.radius : CGFloat(radius!)
        
        let sizeArg: YPBnplPreviewWidgetModel.Appearance.WidgetSize
        if (size == nil) {
            sizeArg = selfAppearance?.size ?? YPBnplPreviewWidgetModel.Appearance.WidgetSize.medium
        } else if (size == "medium") {
            sizeArg = YPBnplPreviewWidgetModel.Appearance.WidgetSize.medium
        } else {
            sizeArg = YPBnplPreviewWidgetModel.Appearance.WidgetSize.small
        }
        
        let appearance = YPBnplPreviewWidgetModel.Appearance(theme: themeArg!, radius: radiusArg!, hasOutline: hasOutline ?? selfAppearance?.hasOutline ?? true, hasPadding: hasPadding ?? selfAppearance?.hasPadding ?? true, hasCheckoutButton: hasCheckoutButton ?? selfAppearance?.hasCheckoutButton ?? false, background: backgroundColorArg, size: sizeArg)
        
        self.args = [
            "amount": amountArg!,
            "appearance": appearance,
            "header": headerArg!,
            "withHeaderClickListener": withHeaderClickListener ?? false,
        ]
        
        if (shouldRebuild) {
            self.viewController!.updateView(args: self.args)
        }
    }
    
    public func view() -> UIView {
        return self.viewController!.view
    }
}

extension UIColor {
    convenience init(argb: String) {
        guard argb.count == 8 else {
            self.init(white: 1.0, alpha: 1.0)
            return
        }

        let alphaHex = String(argb.prefix(2))
        let redHex = String(argb.prefix(4).suffix(2))
        let greenHex = String(argb.prefix(6).suffix(2))
        let blueHex = String(argb.suffix(2))
        
        var alpha: UInt64 = 0
        var red: UInt64 = 0
        var green: UInt64 = 0
        var blue: UInt64 = 0

        Scanner(string: alphaHex).scanHexInt64(&alpha)
        Scanner(string: redHex).scanHexInt64(&red)
        Scanner(string: greenHex).scanHexInt64(&green)
        Scanner(string: blueHex).scanHexInt64(&blue)
        
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 255.0
        )
    }
}

class YpayBNPLWidgetUIViewController : UIViewController, YPPresentationContextProviding {
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
        
        let newSubview = YandexPaySDKApi.instance.createBnplPreviewWidgetView(
            model: YPBnplPreviewWidgetModel(
                amount: self.args["amount"] as! Decimal,
                appearance: self.args["appearance"] as! YPBnplPreviewWidgetModel.Appearance,
                header: self.args["header"] as! YPBnplPreviewWidgetModel.HeaderStyle
            ),
            presentationContextProvider: self,
            delegate: args["header"] as! YPBnplPreviewWidgetModel.HeaderStyle == YPBnplPreviewWidgetModel.HeaderStyle.standardWithCustomAction ? BNPLDelegate(methodChannel: channel, viewId: viewId) : nil
        ) as UIView
        
        widgetView!.removeFromSuperview()
        
        updateSize(newView: newSubview)
        
        widgetView = newSubview
        
        view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widgetView = YandexPaySDKApi.instance.createBnplPreviewWidgetView(model: YPBnplPreviewWidgetModel(amount: self.args["amount"] as! Decimal, appearance: self.args["appearance"] as! YPBnplPreviewWidgetModel.Appearance, header: self.args["header"] as! YPBnplPreviewWidgetModel.HeaderStyle), presentationContextProvider: self, delegate: args["withHeaderClickListener"] as! Bool ? BNPLDelegate(methodChannel: channel, viewId: viewId) : nil)
        
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
        print("BNPL WIDGET Размер: \(widgetSubviewSize)")
        
        channel.invokeMethod("onSizeChanged", arguments: [
            "id": viewId,
            "viewType": "ypay-bnpl-preview-widget-view",
            "width": widgetSubviewSize.width,
            "height": widgetSubviewSize.height
            ]
        )
    }
}

class BNPLDelegate: YandexPayBnplPreviewWidgetDelegate {
    let methodChannel: FlutterMethodChannel
    let viewId: Int64
    
    init(methodChannel: FlutterMethodChannel, viewId: Int64) {
        self.methodChannel = methodChannel
        self.viewId = viewId
    }
    
    func onYandexPayHeaderClick() {
        
        methodChannel.invokeMethod(
            "onEvent",
            arguments: [
                "id": viewId,
                "viewType": "ypay-bnpl-preview-widget-view",
                "event": "onHeaderClick"
            ]
        )
      }
    
    func onYandexPayCheckoutButtonClick(data: YandexPaySDK.YandexPayBnplPreviewWidgetData) {
        methodChannel.invokeMethod(
            "onEvent",
            arguments: [
                "id": viewId,
                "viewType": "ypay-bnpl-preview-widget-view",
                "event": "onCheckoutButtonClick",
                "selectedPlan": data.splitMonthCount
            ]
        )
      }
}
