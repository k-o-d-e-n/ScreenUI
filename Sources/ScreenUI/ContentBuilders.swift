
///
/// Generated by Swift GYB.
///

public struct One<S>: ScreenBuilder where S: Screen {
    public typealias Content = S.Content
    public typealias Context = S.Context
    public let _0: S
    public subscript<T>(next path: KeyPath<Self, T>) -> T {
        self[keyPath: path]
    }
    public func index(of keyPath: PartialKeyPath<Self>) -> Int { 0 }
    public func keyPath(at index: Int) -> PartialKeyPath<Self> { \._0 }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content where From: Screen, From.PathFrom == Self {
        let (c1, _) = _0.makeContent(context, router: router.next(from: _0, isActive: true))
        return c1
    }
}
extension ContentBuilder {
    public static func buildBlock<C0>(_ c0: C0) -> One<C0> {
        One(_0: c0)
    }
}

#if os(macOS) || os(iOS) || os(tvOS)

public struct TwoArr<T0, T1>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen,
T0.Content: Controller, T1.Content: Controller
{
    public typealias PathFrom = (T0, T1)
    public typealias Context = (T0.Context, T1.Context)
    public typealias Content = [Controller]
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let r0 = router.next(from: _0.0, path: \.0, isActive: true)
        let (c0, c00) = _0.0.makeContent(context.0, router: r0)
        r0.state.surface = c00
        let r1 = router.next(from: _0.1, path: \.1, isActive: false)
        let (c1, c01) = _0.1.makeContent(context.1, router: r1)
        r1.state.surface = c01
        return [c0, c1]
    }
}
public struct ThreeArr<T0, T1, T2>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen,
T0.Content: Controller, T1.Content: Controller, T2.Content: Controller
{
    public typealias PathFrom = (T0, T1, T2)
    public typealias Context = (T0.Context, T1.Context, T2.Context)
    public typealias Content = [Controller]
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let r0 = router.next(from: _0.0, path: \.0, isActive: true)
        let (c0, c00) = _0.0.makeContent(context.0, router: r0)
        r0.state.surface = c00
        let r1 = router.next(from: _0.1, path: \.1, isActive: false)
        let (c1, c01) = _0.1.makeContent(context.1, router: r1)
        r1.state.surface = c01
        let r2 = router.next(from: _0.2, path: \.2, isActive: false)
        let (c2, c02) = _0.2.makeContent(context.2, router: r2)
        r2.state.surface = c02
        return [c0, c1, c2]
    }
}
public struct FourArr<T0, T1, T2, T3>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen,
T0.Content: Controller, T1.Content: Controller, T2.Content: Controller, T3.Content: Controller
{
    public typealias PathFrom = (T0, T1, T2, T3)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context)
    public typealias Content = [Controller]
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let r0 = router.next(from: _0.0, path: \.0, isActive: true)
        let (c0, c00) = _0.0.makeContent(context.0, router: r0)
        r0.state.surface = c00
        let r1 = router.next(from: _0.1, path: \.1, isActive: false)
        let (c1, c01) = _0.1.makeContent(context.1, router: r1)
        r1.state.surface = c01
        let r2 = router.next(from: _0.2, path: \.2, isActive: false)
        let (c2, c02) = _0.2.makeContent(context.2, router: r2)
        r2.state.surface = c02
        let r3 = router.next(from: _0.3, path: \.3, isActive: false)
        let (c3, c03) = _0.3.makeContent(context.3, router: r3)
        r3.state.surface = c03
        return [c0, c1, c2, c3]
    }
}
public struct FiveArr<T0, T1, T2, T3, T4>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen,
T0.Content: Controller, T1.Content: Controller, T2.Content: Controller, T3.Content: Controller, T4.Content: Controller
{
    public typealias PathFrom = (T0, T1, T2, T3, T4)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context, T4.Context)
    public typealias Content = [Controller]
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        case \PathFrom.4: return 4
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        case 4: return \.4
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let r0 = router.next(from: _0.0, path: \.0, isActive: true)
        let (c0, c00) = _0.0.makeContent(context.0, router: r0)
        r0.state.surface = c00
        let r1 = router.next(from: _0.1, path: \.1, isActive: false)
        let (c1, c01) = _0.1.makeContent(context.1, router: r1)
        r1.state.surface = c01
        let r2 = router.next(from: _0.2, path: \.2, isActive: false)
        let (c2, c02) = _0.2.makeContent(context.2, router: r2)
        r2.state.surface = c02
        let r3 = router.next(from: _0.3, path: \.3, isActive: false)
        let (c3, c03) = _0.3.makeContent(context.3, router: r3)
        r3.state.surface = c03
        let r4 = router.next(from: _0.4, path: \.4, isActive: false)
        let (c4, c04) = _0.4.makeContent(context.4, router: r4)
        r4.state.surface = c04
        return [c0, c1, c2, c3, c4]
    }
}
public struct SixArr<T0, T1, T2, T3, T4, T5>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen, T5: Screen,
T0.Content: Controller, T1.Content: Controller, T2.Content: Controller, T3.Content: Controller, T4.Content: Controller, T5.Content: Controller
{
    public typealias PathFrom = (T0, T1, T2, T3, T4, T5)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context, T4.Context, T5.Context)
    public typealias Content = [Controller]
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        case \PathFrom.4: return 4
        case \PathFrom.5: return 5
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        case 4: return \.4
        case 5: return \.5
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let r0 = router.next(from: _0.0, path: \.0, isActive: true)
        let (c0, c00) = _0.0.makeContent(context.0, router: r0)
        r0.state.surface = c00
        let r1 = router.next(from: _0.1, path: \.1, isActive: false)
        let (c1, c01) = _0.1.makeContent(context.1, router: r1)
        r1.state.surface = c01
        let r2 = router.next(from: _0.2, path: \.2, isActive: false)
        let (c2, c02) = _0.2.makeContent(context.2, router: r2)
        r2.state.surface = c02
        let r3 = router.next(from: _0.3, path: \.3, isActive: false)
        let (c3, c03) = _0.3.makeContent(context.3, router: r3)
        r3.state.surface = c03
        let r4 = router.next(from: _0.4, path: \.4, isActive: false)
        let (c4, c04) = _0.4.makeContent(context.4, router: r4)
        r4.state.surface = c04
        let r5 = router.next(from: _0.5, path: \.5, isActive: false)
        let (c5, c05) = _0.5.makeContent(context.5, router: r5)
        r5.state.surface = c05
        return [c0, c1, c2, c3, c4, c5]
    }
}
public struct SevenArr<T0, T1, T2, T3, T4, T5, T6>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen, T5: Screen, T6: Screen,
T0.Content: Controller, T1.Content: Controller, T2.Content: Controller, T3.Content: Controller, T4.Content: Controller, T5.Content: Controller, T6.Content: Controller
{
    public typealias PathFrom = (T0, T1, T2, T3, T4, T5, T6)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context, T4.Context, T5.Context, T6.Context)
    public typealias Content = [Controller]
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        case \PathFrom.4: return 4
        case \PathFrom.5: return 5
        case \PathFrom.6: return 6
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        case 4: return \.4
        case 5: return \.5
        case 6: return \.6
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let r0 = router.next(from: _0.0, path: \.0, isActive: true)
        let (c0, c00) = _0.0.makeContent(context.0, router: r0)
        r0.state.surface = c00
        let r1 = router.next(from: _0.1, path: \.1, isActive: false)
        let (c1, c01) = _0.1.makeContent(context.1, router: r1)
        r1.state.surface = c01
        let r2 = router.next(from: _0.2, path: \.2, isActive: false)
        let (c2, c02) = _0.2.makeContent(context.2, router: r2)
        r2.state.surface = c02
        let r3 = router.next(from: _0.3, path: \.3, isActive: false)
        let (c3, c03) = _0.3.makeContent(context.3, router: r3)
        r3.state.surface = c03
        let r4 = router.next(from: _0.4, path: \.4, isActive: false)
        let (c4, c04) = _0.4.makeContent(context.4, router: r4)
        r4.state.surface = c04
        let r5 = router.next(from: _0.5, path: \.5, isActive: false)
        let (c5, c05) = _0.5.makeContent(context.5, router: r5)
        r5.state.surface = c05
        let r6 = router.next(from: _0.6, path: \.6, isActive: false)
        let (c6, c06) = _0.6.makeContent(context.6, router: r6)
        r6.state.surface = c06
        return [c0, c1, c2, c3, c4, c5, c6]
    }
}
public struct EightArr<T0, T1, T2, T3, T4, T5, T6, T7>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen, T5: Screen, T6: Screen, T7: Screen,
T0.Content: Controller, T1.Content: Controller, T2.Content: Controller, T3.Content: Controller, T4.Content: Controller, T5.Content: Controller, T6.Content: Controller, T7.Content: Controller
{
    public typealias PathFrom = (T0, T1, T2, T3, T4, T5, T6, T7)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context, T4.Context, T5.Context, T6.Context, T7.Context)
    public typealias Content = [Controller]
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        case \PathFrom.4: return 4
        case \PathFrom.5: return 5
        case \PathFrom.6: return 6
        case \PathFrom.7: return 7
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        case 4: return \.4
        case 5: return \.5
        case 6: return \.6
        case 7: return \.7
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let r0 = router.next(from: _0.0, path: \.0, isActive: true)
        let (c0, c00) = _0.0.makeContent(context.0, router: r0)
        r0.state.surface = c00
        let r1 = router.next(from: _0.1, path: \.1, isActive: false)
        let (c1, c01) = _0.1.makeContent(context.1, router: r1)
        r1.state.surface = c01
        let r2 = router.next(from: _0.2, path: \.2, isActive: false)
        let (c2, c02) = _0.2.makeContent(context.2, router: r2)
        r2.state.surface = c02
        let r3 = router.next(from: _0.3, path: \.3, isActive: false)
        let (c3, c03) = _0.3.makeContent(context.3, router: r3)
        r3.state.surface = c03
        let r4 = router.next(from: _0.4, path: \.4, isActive: false)
        let (c4, c04) = _0.4.makeContent(context.4, router: r4)
        r4.state.surface = c04
        let r5 = router.next(from: _0.5, path: \.5, isActive: false)
        let (c5, c05) = _0.5.makeContent(context.5, router: r5)
        r5.state.surface = c05
        let r6 = router.next(from: _0.6, path: \.6, isActive: false)
        let (c6, c06) = _0.6.makeContent(context.6, router: r6)
        r6.state.surface = c06
        let r7 = router.next(from: _0.7, path: \.7, isActive: false)
        let (c7, c07) = _0.7.makeContent(context.7, router: r7)
        r7.state.surface = c07
        return [c0, c1, c2, c3, c4, c5, c6, c7]
    }
}
public struct NineArr<T0, T1, T2, T3, T4, T5, T6, T7, T9>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen, T5: Screen, T6: Screen, T7: Screen, T9: Screen,
T0.Content: Controller, T1.Content: Controller, T2.Content: Controller, T3.Content: Controller, T4.Content: Controller, T5.Content: Controller, T6.Content: Controller, T7.Content: Controller, T9.Content: Controller
{
    public typealias PathFrom = (T0, T1, T2, T3, T4, T5, T6, T7, T9)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context, T4.Context, T5.Context, T6.Context, T7.Context, T9.Context)
    public typealias Content = [Controller]
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        case \PathFrom.4: return 4
        case \PathFrom.5: return 5
        case \PathFrom.6: return 6
        case \PathFrom.7: return 7
        case \PathFrom.8: return 8
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        case 4: return \.4
        case 5: return \.5
        case 6: return \.6
        case 7: return \.7
        case 8: return \.8
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let r0 = router.next(from: _0.0, path: \.0, isActive: true)
        let (c0, c00) = _0.0.makeContent(context.0, router: r0)
        r0.state.surface = c00
        let r1 = router.next(from: _0.1, path: \.1, isActive: false)
        let (c1, c01) = _0.1.makeContent(context.1, router: r1)
        r1.state.surface = c01
        let r2 = router.next(from: _0.2, path: \.2, isActive: false)
        let (c2, c02) = _0.2.makeContent(context.2, router: r2)
        r2.state.surface = c02
        let r3 = router.next(from: _0.3, path: \.3, isActive: false)
        let (c3, c03) = _0.3.makeContent(context.3, router: r3)
        r3.state.surface = c03
        let r4 = router.next(from: _0.4, path: \.4, isActive: false)
        let (c4, c04) = _0.4.makeContent(context.4, router: r4)
        r4.state.surface = c04
        let r5 = router.next(from: _0.5, path: \.5, isActive: false)
        let (c5, c05) = _0.5.makeContent(context.5, router: r5)
        r5.state.surface = c05
        let r6 = router.next(from: _0.6, path: \.6, isActive: false)
        let (c6, c06) = _0.6.makeContent(context.6, router: r6)
        r6.state.surface = c06
        let r7 = router.next(from: _0.7, path: \.7, isActive: false)
        let (c7, c07) = _0.7.makeContent(context.7, router: r7)
        r7.state.surface = c07
        let r8 = router.next(from: _0.8, path: \.8, isActive: false)
        let (c8, c08) = _0.8.makeContent(context.8, router: r8)
        r8.state.surface = c08
        return [c0, c1, c2, c3, c4, c5, c6, c7, c8]
    }
}

extension ContentBuilder {
    public static func buildBlock<T0, T1>(
    _ c0: T0, _ c1: T1
    ) -> TwoArr<T0, T1> {
        TwoArr(_0: (c0, c1))
    }
    public static func buildBlock<T0, T1, T2>(
    _ c0: T0, _ c1: T1, _ c2: T2
    ) -> ThreeArr<T0, T1, T2> {
        ThreeArr(_0: (c0, c1, c2))
    }
    public static func buildBlock<T0, T1, T2, T3>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3
    ) -> FourArr<T0, T1, T2, T3> {
        FourArr(_0: (c0, c1, c2, c3))
    }
    public static func buildBlock<T0, T1, T2, T3, T4>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3, _ c4: T4
    ) -> FiveArr<T0, T1, T2, T3, T4> {
        FiveArr(_0: (c0, c1, c2, c3, c4))
    }
    public static func buildBlock<T0, T1, T2, T3, T4, T5>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3, _ c4: T4, _ c5: T5
    ) -> SixArr<T0, T1, T2, T3, T4, T5> {
        SixArr(_0: (c0, c1, c2, c3, c4, c5))
    }
    public static func buildBlock<T0, T1, T2, T3, T4, T5, T6>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3, _ c4: T4, _ c5: T5, _ c6: T6
    ) -> SevenArr<T0, T1, T2, T3, T4, T5, T6> {
        SevenArr(_0: (c0, c1, c2, c3, c4, c5, c6))
    }
    public static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3, _ c4: T4, _ c5: T5, _ c6: T6, _ c7: T7
    ) -> EightArr<T0, T1, T2, T3, T4, T5, T6, T7> {
        EightArr(_0: (c0, c1, c2, c3, c4, c5, c6, c7))
    }
    public static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7, T9>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3, _ c4: T4, _ c5: T5, _ c6: T6, _ c7: T7, _ c8: T9
    ) -> NineArr<T0, T1, T2, T3, T4, T5, T6, T7, T9> {
        NineArr(_0: (c0, c1, c2, c3, c4, c5, c6, c7, c8))
    }
}

#endif

#if canImport(SwiftUI) && canImport(Combine)
import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct TwoView<T0, T1>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen,
T0.Content: View, T1.Content: View
{
    public typealias PathFrom = (T0, T1)
    public typealias Context = (T0.Context, T1.Context)
    public typealias Content = (AnyView, AnyView)
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let (c0, _) = _0.0.makeContent(context.0, router: router.next(from: _0.0, path: \.0, isActive: true))
        let (c1, _) = _0.1.makeContent(context.1, router: router.next(from: _0.1, path: \.1, isActive: false))
        return (AnyView(c0.tag(0)), AnyView(c1.tag(1)))
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ThreeView<T0, T1, T2>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen,
T0.Content: View, T1.Content: View, T2.Content: View
{
    public typealias PathFrom = (T0, T1, T2)
    public typealias Context = (T0.Context, T1.Context, T2.Context)
    public typealias Content = (AnyView, AnyView, AnyView)
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let (c0, _) = _0.0.makeContent(context.0, router: router.next(from: _0.0, path: \.0, isActive: true))
        let (c1, _) = _0.1.makeContent(context.1, router: router.next(from: _0.1, path: \.1, isActive: false))
        let (c2, _) = _0.2.makeContent(context.2, router: router.next(from: _0.2, path: \.2, isActive: false))
        return (AnyView(c0.tag(0)), AnyView(c1.tag(1)), AnyView(c2.tag(2)))
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct FourView<T0, T1, T2, T3>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen,
T0.Content: View, T1.Content: View, T2.Content: View, T3.Content: View
{
    public typealias PathFrom = (T0, T1, T2, T3)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context)
    public typealias Content = (AnyView, AnyView, AnyView, AnyView)
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let (c0, _) = _0.0.makeContent(context.0, router: router.next(from: _0.0, path: \.0, isActive: true))
        let (c1, _) = _0.1.makeContent(context.1, router: router.next(from: _0.1, path: \.1, isActive: false))
        let (c2, _) = _0.2.makeContent(context.2, router: router.next(from: _0.2, path: \.2, isActive: false))
        let (c3, _) = _0.3.makeContent(context.3, router: router.next(from: _0.3, path: \.3, isActive: false))
        return (AnyView(c0.tag(0)), AnyView(c1.tag(1)), AnyView(c2.tag(2)), AnyView(c3.tag(3)))
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct FiveView<T0, T1, T2, T3, T4>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen,
T0.Content: View, T1.Content: View, T2.Content: View, T3.Content: View, T4.Content: View
{
    public typealias PathFrom = (T0, T1, T2, T3, T4)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context, T4.Context)
    public typealias Content = (AnyView, AnyView, AnyView, AnyView, AnyView)
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        case \PathFrom.4: return 4
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        case 4: return \.4
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let (c0, _) = _0.0.makeContent(context.0, router: router.next(from: _0.0, path: \.0, isActive: true))
        let (c1, _) = _0.1.makeContent(context.1, router: router.next(from: _0.1, path: \.1, isActive: false))
        let (c2, _) = _0.2.makeContent(context.2, router: router.next(from: _0.2, path: \.2, isActive: false))
        let (c3, _) = _0.3.makeContent(context.3, router: router.next(from: _0.3, path: \.3, isActive: false))
        let (c4, _) = _0.4.makeContent(context.4, router: router.next(from: _0.4, path: \.4, isActive: false))
        return (AnyView(c0.tag(0)), AnyView(c1.tag(1)), AnyView(c2.tag(2)), AnyView(c3.tag(3)), AnyView(c4.tag(4)))
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SixView<T0, T1, T2, T3, T4, T5>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen, T5: Screen,
T0.Content: View, T1.Content: View, T2.Content: View, T3.Content: View, T4.Content: View, T5.Content: View
{
    public typealias PathFrom = (T0, T1, T2, T3, T4, T5)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context, T4.Context, T5.Context)
    public typealias Content = (AnyView, AnyView, AnyView, AnyView, AnyView, AnyView)
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        case \PathFrom.4: return 4
        case \PathFrom.5: return 5
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        case 4: return \.4
        case 5: return \.5
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let (c0, _) = _0.0.makeContent(context.0, router: router.next(from: _0.0, path: \.0, isActive: true))
        let (c1, _) = _0.1.makeContent(context.1, router: router.next(from: _0.1, path: \.1, isActive: false))
        let (c2, _) = _0.2.makeContent(context.2, router: router.next(from: _0.2, path: \.2, isActive: false))
        let (c3, _) = _0.3.makeContent(context.3, router: router.next(from: _0.3, path: \.3, isActive: false))
        let (c4, _) = _0.4.makeContent(context.4, router: router.next(from: _0.4, path: \.4, isActive: false))
        let (c5, _) = _0.5.makeContent(context.5, router: router.next(from: _0.5, path: \.5, isActive: false))
        return (AnyView(c0.tag(0)), AnyView(c1.tag(1)), AnyView(c2.tag(2)), AnyView(c3.tag(3)), AnyView(c4.tag(4)), AnyView(c5.tag(5)))
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SevenView<T0, T1, T2, T3, T4, T5, T6>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen, T5: Screen, T6: Screen,
T0.Content: View, T1.Content: View, T2.Content: View, T3.Content: View, T4.Content: View, T5.Content: View, T6.Content: View
{
    public typealias PathFrom = (T0, T1, T2, T3, T4, T5, T6)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context, T4.Context, T5.Context, T6.Context)
    public typealias Content = (AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView)
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        case \PathFrom.4: return 4
        case \PathFrom.5: return 5
        case \PathFrom.6: return 6
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        case 4: return \.4
        case 5: return \.5
        case 6: return \.6
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let (c0, _) = _0.0.makeContent(context.0, router: router.next(from: _0.0, path: \.0, isActive: true))
        let (c1, _) = _0.1.makeContent(context.1, router: router.next(from: _0.1, path: \.1, isActive: false))
        let (c2, _) = _0.2.makeContent(context.2, router: router.next(from: _0.2, path: \.2, isActive: false))
        let (c3, _) = _0.3.makeContent(context.3, router: router.next(from: _0.3, path: \.3, isActive: false))
        let (c4, _) = _0.4.makeContent(context.4, router: router.next(from: _0.4, path: \.4, isActive: false))
        let (c5, _) = _0.5.makeContent(context.5, router: router.next(from: _0.5, path: \.5, isActive: false))
        let (c6, _) = _0.6.makeContent(context.6, router: router.next(from: _0.6, path: \.6, isActive: false))
        return (AnyView(c0.tag(0)), AnyView(c1.tag(1)), AnyView(c2.tag(2)), AnyView(c3.tag(3)), AnyView(c4.tag(4)), AnyView(c5.tag(5)), AnyView(c6.tag(6)))
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct EightView<T0, T1, T2, T3, T4, T5, T6, T7>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen, T5: Screen, T6: Screen, T7: Screen,
T0.Content: View, T1.Content: View, T2.Content: View, T3.Content: View, T4.Content: View, T5.Content: View, T6.Content: View, T7.Content: View
{
    public typealias PathFrom = (T0, T1, T2, T3, T4, T5, T6, T7)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context, T4.Context, T5.Context, T6.Context, T7.Context)
    public typealias Content = (AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView)
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        case \PathFrom.4: return 4
        case \PathFrom.5: return 5
        case \PathFrom.6: return 6
        case \PathFrom.7: return 7
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        case 4: return \.4
        case 5: return \.5
        case 6: return \.6
        case 7: return \.7
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let (c0, _) = _0.0.makeContent(context.0, router: router.next(from: _0.0, path: \.0, isActive: true))
        let (c1, _) = _0.1.makeContent(context.1, router: router.next(from: _0.1, path: \.1, isActive: false))
        let (c2, _) = _0.2.makeContent(context.2, router: router.next(from: _0.2, path: \.2, isActive: false))
        let (c3, _) = _0.3.makeContent(context.3, router: router.next(from: _0.3, path: \.3, isActive: false))
        let (c4, _) = _0.4.makeContent(context.4, router: router.next(from: _0.4, path: \.4, isActive: false))
        let (c5, _) = _0.5.makeContent(context.5, router: router.next(from: _0.5, path: \.5, isActive: false))
        let (c6, _) = _0.6.makeContent(context.6, router: router.next(from: _0.6, path: \.6, isActive: false))
        let (c7, _) = _0.7.makeContent(context.7, router: router.next(from: _0.7, path: \.7, isActive: false))
        return (AnyView(c0.tag(0)), AnyView(c1.tag(1)), AnyView(c2.tag(2)), AnyView(c3.tag(3)), AnyView(c4.tag(4)), AnyView(c5.tag(5)), AnyView(c6.tag(6)), AnyView(c7.tag(7)))
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct NineView<T0, T1, T2, T3, T4, T5, T6, T7, T9>: ScreenBuilder, _ScreenBuilder
where T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen, T5: Screen, T6: Screen, T7: Screen, T9: Screen,
T0.Content: View, T1.Content: View, T2.Content: View, T3.Content: View, T4.Content: View, T5.Content: View, T6.Content: View, T7.Content: View, T9.Content: View
{
    public typealias PathFrom = (T0, T1, T2, T3, T4, T5, T6, T7, T9)
    public typealias Context = (T0.Context, T1.Context, T2.Context, T3.Context, T4.Context, T5.Context, T6.Context, T7.Context, T9.Context)
    public typealias Content = (AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView)
    let _0: PathFrom
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int {
        switch keyPath {
        case \PathFrom.0: return 0
        case \PathFrom.1: return 1
        case \PathFrom.2: return 2
        case \PathFrom.3: return 3
        case \PathFrom.4: return 4
        case \PathFrom.5: return 5
        case \PathFrom.6: return 6
        case \PathFrom.7: return 7
        case \PathFrom.8: return 8
        default: return 0
        }
    }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> {
        switch index {
        case 0: return \.0
        case 1: return \.1
        case 2: return \.2
        case 3: return \.3
        case 4: return \.4
        case 5: return \.5
        case 6: return \.6
        case 7: return \.7
        case 8: return \.8
        default: return \.0
        }
    }
    public func makeContent<From>(_ context: Context, router: Router<From>) -> Content
    where PathFrom == From.PathFrom, From : ContentScreen {
        let (c0, _) = _0.0.makeContent(context.0, router: router.next(from: _0.0, path: \.0, isActive: true))
        let (c1, _) = _0.1.makeContent(context.1, router: router.next(from: _0.1, path: \.1, isActive: false))
        let (c2, _) = _0.2.makeContent(context.2, router: router.next(from: _0.2, path: \.2, isActive: false))
        let (c3, _) = _0.3.makeContent(context.3, router: router.next(from: _0.3, path: \.3, isActive: false))
        let (c4, _) = _0.4.makeContent(context.4, router: router.next(from: _0.4, path: \.4, isActive: false))
        let (c5, _) = _0.5.makeContent(context.5, router: router.next(from: _0.5, path: \.5, isActive: false))
        let (c6, _) = _0.6.makeContent(context.6, router: router.next(from: _0.6, path: \.6, isActive: false))
        let (c7, _) = _0.7.makeContent(context.7, router: router.next(from: _0.7, path: \.7, isActive: false))
        let (c8, _) = _0.8.makeContent(context.8, router: router.next(from: _0.8, path: \.8, isActive: false))
        return (AnyView(c0.tag(0)), AnyView(c1.tag(1)), AnyView(c2.tag(2)), AnyView(c3.tag(3)), AnyView(c4.tag(4)), AnyView(c5.tag(5)), AnyView(c6.tag(6)), AnyView(c7.tag(7)), AnyView(c8.tag(8)))
    }
}

extension ContentBuilder {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public static func buildBlock<T0, T1>(
    _ c0: T0, _ c1: T1
    ) -> TwoView<T0, T1> {
        TwoView(_0: (c0, c1))
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public static func buildBlock<T0, T1, T2>(
    _ c0: T0, _ c1: T1, _ c2: T2
    ) -> ThreeView<T0, T1, T2> {
        ThreeView(_0: (c0, c1, c2))
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public static func buildBlock<T0, T1, T2, T3>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3
    ) -> FourView<T0, T1, T2, T3> {
        FourView(_0: (c0, c1, c2, c3))
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public static func buildBlock<T0, T1, T2, T3, T4>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3, _ c4: T4
    ) -> FiveView<T0, T1, T2, T3, T4> {
        FiveView(_0: (c0, c1, c2, c3, c4))
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public static func buildBlock<T0, T1, T2, T3, T4, T5>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3, _ c4: T4, _ c5: T5
    ) -> SixView<T0, T1, T2, T3, T4, T5> {
        SixView(_0: (c0, c1, c2, c3, c4, c5))
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public static func buildBlock<T0, T1, T2, T3, T4, T5, T6>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3, _ c4: T4, _ c5: T5, _ c6: T6
    ) -> SevenView<T0, T1, T2, T3, T4, T5, T6> {
        SevenView(_0: (c0, c1, c2, c3, c4, c5, c6))
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3, _ c4: T4, _ c5: T5, _ c6: T6, _ c7: T7
    ) -> EightView<T0, T1, T2, T3, T4, T5, T6, T7> {
        EightView(_0: (c0, c1, c2, c3, c4, c5, c6, c7))
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7, T9>(
    _ c0: T0, _ c1: T1, _ c2: T2, _ c3: T3, _ c4: T4, _ c5: T5, _ c6: T6, _ c7: T7, _ c8: T9
    ) -> NineView<T0, T1, T2, T3, T4, T5, T6, T7, T9> {
        NineView(_0: (c0, c1, c2, c3, c4, c5, c6, c7, c8))
    }
}
#endif
