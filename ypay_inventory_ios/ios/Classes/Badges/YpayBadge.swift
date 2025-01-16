import Flutter
import YandexPaySDK

public class YpayBadgeFactory : NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
    
    public init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {

        let methodChannel = FlutterMethodChannel(name: "com.yandex.pay.flutter_channel/ypay-badge-view_" +  "\(viewId)", binaryMessenger: messenger)

        return YpayBadgeView(frame, viewId: viewId, methodChannel: methodChannel,  args: args)!
    }
}

public class YpayBadgeView : NSObject, FlutterPlatformView  {
    let viewId: Int64
    let methodChannel: FlutterMethodChannel
    var args: [String: Any]
    var viewController: YpayBadgeUIViewController?
    
    init?(_ frame: CGRect, viewId: Int64, methodChannel: FlutterMethodChannel, args: Any?) {
        self.viewId = viewId
        self.methodChannel = methodChannel
        self.args = [:]
        super.init()
        
        self.updateArgs(args: args, shouldRebuild: false)
        
        self.viewController = YpayBadgeUIViewController(args: self.args, channel: methodChannel, viewId: viewId)

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
        let align = callArgs["align"] as? String
        let variant = callArgs["variant"] as? String
        let color = callArgs["color"] as? String
        let style = callArgs["style"] as? String
        
        let selfAmount = self.args["amount"]

        let amountArg = amount == nil ? selfAmount : Decimal(amount!)
        
        let themeArg = YPTheme(rawValue: theme ?? "system")
        let alignArg = YPBadgeModel.Align(rawValue: align ?? "left")
        let variantArg: Any!
        let colorArg: Any!
        
        if (style == "cashback") {
            variantArg = YPBadgeModel.CashbackVariant(rawValue: variant ?? "`default`")
            colorArg = YPBadgeModel.CashbackColor(rawValue: color ?? "primary")
        } else {
            variantArg = YPBadgeModel.SplitVariant(rawValue: variant ?? "detailed")
            colorArg = YPBadgeModel.SplitColor(rawValue: color ?? "primary")
        }
        
        self.args = [
            "amount": amountArg!,
            "theme": themeArg!,
            "align": alignArg!,
            "variant": variantArg!,
            "color": colorArg!,
            "style": style!,
        ]
        
        if (shouldRebuild) {
            self.viewController!.updateView(args: self.args)
        }
    }
    
    public func view() -> UIView {
        return self.viewController!.view
    }
}

class YpayBadgeUIViewController : UIViewController{
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var args: [String: Any]!
    let channel: FlutterMethodChannel
    let viewId: Int64
    
    var badgeView: UIView?
    
    init(args: [String: Any], channel: FlutterMethodChannel, viewId: Int64) {
        self.channel = channel
        self.args = args
        self.viewId = viewId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    func updateView(args: [String: Any]) {
        self.args.removeAll()
        self.args = args
        
        let newSubview = YandexPaySDKApi.instance.createBadgeView(
            model: YPBadgeModel(
                amount: self.args["amount"] as! Decimal,
                currency: YPCurrencyCode.rub,
                theme: self.args["theme"] as! YPTheme,
                align: self.args["align"] as! YPBadgeModel.Align,
                type: (self.args["style"] as! String) == "cashback" ? .cashback(color: self.args["color"] as! YPBadgeModel.CashbackColor, variant: self.args["variant"] as! YPBadgeModel.CashbackVariant) : .split(color: self.args["color"] as! YPBadgeModel.SplitColor, variant: self.args["variant"] as! YPBadgeModel.SplitVariant)
            )
        ) as UIView
        
        badgeView!.removeFromSuperview()
        
        updateSize(newView: newSubview)
        
        badgeView = newSubview
        
        view.layoutIfNeeded()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        badgeView = YandexPaySDKApi.instance.createBadgeView(
            model: YPBadgeModel(
                amount: self.args["amount"] as! Decimal,
                currency: YPCurrencyCode.rub,
                theme: self.args["theme"] as! YPTheme,
                align: self.args["align"] as! YPBadgeModel.Align,
                type: (self.args["style"] as! String) == "cashback" ? .cashback(color: self.args["color"] as! YPBadgeModel.CashbackColor, variant: self.args["variant"] as! YPBadgeModel.CashbackVariant) : .split(color: self.args["color"] as! YPBadgeModel.SplitColor, variant: self.args["variant"] as! YPBadgeModel.SplitVariant)
            )
        )
        
        updateSize(newView: badgeView!)
        view.layoutIfNeeded()
    }
    
    private func updateSize(newView: UIView) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(newView)
        
        let width = newView.bounds.width
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)

        let fittingSize = newView.sizeThatFits(targetSize)

        newView.frame = CGRect(x: 0, y: 0, width: width, height: fittingSize.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let badgeView = self.view.subviews.first!
        let badgeViewSize = badgeView.frame.size
        print("BADGE Размер: \(badgeViewSize)")
        
        channel.invokeMethod("onSizeChanged", arguments: [
            "id": viewId,
            "viewType": "ypay-badge-view",
            "width": badgeViewSize.width,
            "height": badgeViewSize.height
            ]
        )
    }
}
