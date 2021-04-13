//
//  ActionButton.swift
//  Moovizy
//
//  Created by jerome on 06/04/2018.
//  Copyright © 2018 CITYWAY. All rights reserved.
//

import UIKit
import NSAttributedStringBuilder
import ColorExtension
import FontExtension
import StringExtension
import UIViewExtension
import SnapKit
import Haptica
import Peep

open class FeedbackButton: UIButton {
    public init() {
        super.init(frame: .zero)
        addFeedback()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addFeedback()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        addFeedback()
    }
    public var usesHaptics: Bool = true  {
        didSet {
            isHaptic = usesHaptics
            hapticType = hapticValue
        }
    }
    public var hapticValue: Haptic = .impact(.medium)
    public var hapticSequence: [Note]? = nil //[.haptic(.impact(.light)), .haptic(.impact(.heavy)), .wait(0.1), .haptic(.impact(.heavy)), .haptic(.impact(.light))]
    // MARK: - Sound
    public var playSoundOnTouch: Bool = true
    public var sound: Peepable = KeyPress.tap
    
    private func addFeedback() {
        addTarget(self, action: #selector(handleFeedback), for: .touchUpInside)
    }
    
    @objc func handleFeedback() {
        if playSoundOnTouch {
            Peep.play(sound: sound)
        }
        if usesHaptics {
            if let notes = hapticSequence {
                Haptic.play(notes)
            } else {
                hapticValue.generate()
            }
        }
    }
}

public enum ActionButtonType {
    case primary
    case secondary
    case confirmation
    case complementary
    case connection(type: ConnectionType)
    case smoked
    case alert
    case loading
    case animated
    case swipeCardButton(isYesButton: Bool)
    case progress(backgroundColor: UIColor?, fillColor: UIColor?)
    
    public enum ConnectionType {
        case facebook
        case google
//        case apple
        
        var image: UIImage? {
            switch self {
            case .facebook: return UIImage(named: "facebook")
            case .google: return UIImage(named: "google")
//            case .apple: return UIImage(named: "apple")
            }
        }
        
        var title: String {
            switch self {
            case .facebook: return "Connect with facebook".local()
            case .google: return "Connect with google".local()
            }
        }
    }
    
    
    var strokeColor: UIColor? {
        switch self {
        case .primary: return ActionButton.primaryColor
        default: return nil
        }
    }
    
    var strokeWidth: CGFloat {
        switch self {
        default:
            return 0
        }
    }
    
    var textColor: UIColor? {
        switch self {
        case .secondary: return ActionButton.textOnPrimaryColor
        case .animated: return ActionButton.mainTextsColor
        case .loading: return UIColor.white.withAlphaComponent(0.7)
        case .alert: return .white
        default: return .white
        }
    }
    
    var shadowColor: UIColor? {
        switch self {
        case .connection: return UIColor.black
        default: return nil
        }
    }
    
    var fontType: UIFont.TextStyle {
        switch self {
        default: return .headline
        }
    }
    
    var textShadowColor: UIColor? {
        switch self {
        default: return nil
        }
    }
    
    var mainColor: UIColor? {
        switch self {
        case .primary: return ActionButton.primaryColor
        case .secondary: return ActionButton.secondaryColor
        case .connection: return ActionButton.primaryColor
        case .smoked: return ActionButton.separatorColor
        case .alert: return ActionButton.alertColor
        case .loading: return ActionButton.primaryColor
        case .confirmation: return ActionButton.confirmationColor
        case .complementary: return ActionButton.complementaryColor
        case .animated: return .white
        case .swipeCardButton(let isYesButton): return isYesButton ? ActionButton.alertColor : ActionButton.confirmationColor
        case .progress(let backgroundColor, _): return backgroundColor ?? ActionButton.mainTextsColor
        }
    }
    
    func updateBackground(for button: UIButton) {
        button.setBackgroundImage(nil, for: .normal)
        
        switch self {
        case .primary:
            button.backgroundColor = ActionButton.primaryColor
            
        case .secondary:
            button.backgroundColor = ActionButton.secondaryColor
            
        case .connection(let type):
            switch type {
            case .facebook: button.backgroundColor = UIColor.init(hexString: "#3b5998")
            case .google: button.backgroundColor = UIColor.init(hexString: "#DB4437")
            }
            button.setImage(type.image, for: .normal)
            button.setTitle(type.title, for: .normal)
            
        case .smoked:
            button.backgroundColor = mainColor
            
        case .alert:
            button.backgroundColor = ActionButton.alertColor
            
        case .complementary:
            button.backgroundColor = ActionButton.complementaryColor
            
        case .loading:
            button.backgroundColor = ActionButton.loadingColor
            
        case .confirmation:
            button.backgroundColor = ActionButton.confirmationColor
            
        case .animated:
            button.backgroundColor = .white
            
        case .swipeCardButton(let isYesButton):
            button.backgroundColor = isYesButton ? ActionButton.alertColor : ActionButton.confirmationColor
            
        case .progress(let backgroundColor, _):
            button.backgroundColor = backgroundColor ?? ActionButton.mainTextsColor
        }
    }
}

extension ActionButtonType: Equatable {}
public func == (lhs: ActionButtonType, rhs: ActionButtonType) -> Bool {
    switch (lhs, rhs) {
    case (.secondary, .secondary): return true
    case (.smoked, .smoked): return true
    case (.connection(let lhsType), .connection(let rhsType)):
        switch (lhsType, rhsType) {
        case (.facebook, .facebook): return true
        case (.google, .google): return true
        default: return false
        }
    default: return false
    }
}

public typealias ActionButtonConfigurationData = (type: ActionButtonType, title: String, completion: (() -> Void)?)

public class ActionButton: FeedbackButton {
    public static var primaryColor: UIColor = #colorLiteral(red: 0.8313725591, green: 0.2156862766, blue: 0.180392161, alpha: 1)
    public static var secondaryColor: UIColor = #colorLiteral(red: 0.1176470593, green: 0.1294117719, blue: 0.1568627506, alpha: 1)
    public static var mainTextsColor: UIColor = #colorLiteral(red: 0.9686274529, green: 0.9764705896, blue: 0.9882352948, alpha: 1)
    public static var textOnPrimaryColor: UIColor = #colorLiteral(red: 0.9686274529, green: 0.9764705896, blue: 0.9882352948, alpha: 1)
    public static var alertColor: UIColor = .red
    public static var confirmationColor: UIColor = #colorLiteral(red: 0.5176470876, green: 0.7372549176, blue: 0.3333333433, alpha: 1)
    public static var separatorColor: UIColor = .gray
    public static var loadingColor: UIColor = #colorLiteral(red: 0.9019607902, green: 0.3490196168, blue: 0.3254902065, alpha: 1)
    public static var complementaryColor: UIColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    // global settings
    public static var useUppercasedTitles: Bool = true
    /// you can set a shape staically for all buttons or use a custom shape on each button
    public static var globalShape: UIView.ComponentShape = .rounded(value: 5)
    public var shape: UIView.ComponentShape?
    // per component setting
    public var useUppercasedTitles: Bool = true
    // progress stuff
    var timer: Timer?
    private var loadingView: PlainProgressBar?
    public var progress: CGFloat = 0  {
        didSet {
            setNeedsLayout()
        }
    }
    var shouldUpdateProgress: Bool = true
    
    public override var isEnabled: Bool  {
        didSet {
            DispatchQueue.main.async {
                if self.isEnabled {
                    // have to use a variable to be able to assign variable to itself :-/
                    self.updateButton(for: self.actionButtonType)
                } else {
                    self.updateButton(for: .smoked)
                }
            }
        }
    }
    
    private var _savedTitle: String?
    public var isLoading: Bool = false {
        didSet {
            if isLoading == false, loader.superview != nil {
                setTitle(_savedTitle, for: .normal)
                // have to use a variable to be able to assign variable to itself :-/
                updateButton(for: actionButtonType)
            } else if loader.superview == nil, isLoading == true {
                _savedTitle = titleLabel?.text
                setTitle(" ", for: .normal)
                updateButton(for: .loading)
            }
        }
    }

    public var textColor: UIColor? {
        get {
            if let textColor = self._textColor {
                return textColor
            }
            return actionButtonType.textColor
        }
        set {
            self._textColor = newValue
            self.updateText()
        }
    }
    private var _textColor: UIColor?
    
    public lazy var loader: UIActivityIndicatorView = {
        $0.hidesWhenStopped = true
        $0.color = self.actionButtonType.textColor
        return $0
    } (UIActivityIndicatorView(style: .white))

    private func updateText() {
        if let attributedTitle = self.attributedTitle(for: .normal) {
            self.setTitle(attributedTitle.string, for: .normal)
            return
        }
        
        if let title = self.title(for: .normal) {
            self.setTitle(title, for: .normal)
            return
        }
    }
    
    public var fontType: UIFont.TextStyle?
    
    public var actionButtonType: ActionButtonType = .primary {
        didSet {
            if isEnabled {
                // have to use a variable to be able to assign variable to itself :-/
                updateButton(for: actionButtonType)
            } else {
                updateButton(for: .smoked)
            }
        }
    }
    
    // update the button's layout for a given type without changing its initial actionButtonType
    private func updateButton(for type: ActionButtonType) {
        
        if loader.superview != nil {
            loader.removeFromSuperview()
            loader.stopAnimating()
            layoutIfNeeded()
        }
        hapticSequence = [.haptic(.impact(.light)), .haptic(.impact(.heavy)), .wait(0.1), .haptic(.impact(.heavy)), .haptic(.impact(.light))]
        titleLabel?.typeObserver = true
        titleLabel?.minimumScaleFactor = 0.5
        titleLabel?.adjustsFontSizeToFitWidth = true
        clipsToBounds = false
        type.updateBackground(for: self)
        layer.borderColor = type.strokeColor?.cgColor
        layer.borderWidth = type.strokeWidth
        if let shadowColor = type.shadowColor {
            layer.shadowColor = shadowColor.cgColor
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.5
            layer.shadowOffset = .zero
        }
        titleEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)//.zero
        
        switch type {
        case .connection:
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 12)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            contentHorizontalAlignment = .center
            
        case .loading:
            addSubview(loader)
            loader.startAnimating()
            loader.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            switch actionButtonType {
            case .progress(let backgroundColor, _): self.backgroundColor = backgroundColor?.withAlphaComponent(0.5) ?? ActionButton.mainTextsColor.withAlphaComponent(0.5)
                
            default: ()
            }
            
        case .progress(_, let color):
            if loadingView == nil {
                progress = 0.0
                loadingView = PlainProgressBar(frame: bounds)
                loadingView?.color = color ?? .gray
                insertSubview(loadingView!, at: 0)
                loadingView?.snp.makeConstraints({ make in
                    make.edges.equalToSuperview()
                })
                (shape ?? ActionButton.globalShape).applyShape(on: loadingView!)
                loadingView?.isUserInteractionEnabled = false
            }
        
        default:
            loadingView?.removeFromSuperview()
            loadingView = nil
            timer?.invalidate()
            contentEdgeInsets = .zero
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)//.zero
            contentHorizontalAlignment = .center
        }
        
        layoutSubviews()
    }

    
    public init(frame: CGRect = .zero, type: ActionButtonType = .primary) {
        defer {
            actionButtonType = type
        }
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        actionButtonType = .primary
    }

    public override func setTitle(_ title: String?, for state: UIControl.State) {
        var title = title
        if (useUppercasedTitles != ActionButton.useUppercasedTitles && useUppercasedTitles == true) || ActionButton.useUppercasedTitles == true {
            title = title?.uppercased()
        }
        self.setTitle(title, for: state, with: nil)
    }

    public func setTitle(_ title: String?, for state: UIControl.State, with color: UIColor?) {
        super.setAttributedTitle(attributedString(for: title, with: color), for: state)
    }
    
    private func attributedString(for title: String?, with color: UIColor?) -> NSAttributedString? {
        var title = title
        if (useUppercasedTitles != ActionButton.useUppercasedTitles && useUppercasedTitles == true) || ActionButton.useUppercasedTitles == true {
            title = title?.uppercased()
        }
        var attr: NSAttributedString!
        switch actionButtonType {
        default:
            attr = title?.asAttributedString(for: fontType ?? actionButtonType.fontType, textColor: (color ?? actionButtonType.textColor) ?? .black)
        }
        if let shadowColor = actionButtonType.textShadowColor {
            attr = AText.init(attr.string, attributes: attr.attributes(at: 0, effectiveRange: nil)).shadow(color: shadowColor, radius: 5.0, x: 2, y: 2).attributedString
        }
        return attr
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        (shape ?? ActionButton.globalShape).applyShape(on: self)
        if case let ActionButtonType.progress(_, _) = actionButtonType,
           shouldUpdateProgress {
            loadingView?.progress = progress
        }
    }    
}

public extension ActionButton {
    func startProgressUpdate(at start: CGFloat = 0, for time: CGFloat, endCompletion: @escaping (() -> Void)) {
        progress = start / time
        timer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                     repeats: true,
                                     block: { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.progress += (0.1 / time)
                
                guard self.timer != nil,
                      self.progress < 1 else {
                        self.progress = 1
                    self.timer?.invalidate()
                    self.timer = nil
                    endCompletion()
                    return
                }
            }
        })
    }
    
    func stopProgress() {
        shouldUpdateProgress = false
    }
    
    func restartTimer(completion: @escaping ((Bool) -> Void)) {
        shouldUpdateProgress = true
    }
}
