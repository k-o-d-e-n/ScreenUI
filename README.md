# ScreenUI

A multi-platform, multi-paradigm routing framework for iOS/macOS and others, the replacement of Storyboard.
Supports `UIKit`, `AppKit`, `SwiftUI`.

```swift
    static let transitionsMap = AppScreen(
        Delegate(
            root: ConditionalWindow {
                Launch()
                Welcome(
                    login: Present(Navigation(Login())),
                    registration: Present(Navigation(Registration()))
                )
                Tabs {
                    Navigation(
                        Feed(
                            page: Push(Page()),
                            match: Push(Match()),
                            gameDay: Push(GameDay(match: Push(Match()))),
                            tournament: Push(Tournament(match: Push(Match())))
                        )
                    )
                    Navigation(
                        Search(
                            filter: AnySearchFilter()
                                .navigation()
                                .configContent({ $0.isToolbarHidden = false })
                                .present(),
                            user: Present(Navigation(Player(team: Push(Team())))),
                            team: Team(player: Player().push())
                                .navigation()
                                .present(),
                            league: Present(Navigation(League())),
                            match: Present(Navigation(Match()))
                        )
                    )
                    Navigation(
                        Dashboard(
                            edit: Flow(base: UserEdit(editable: true)).present(),
                            entities: .init(
                                user: Push(Player(team: Team().navigation().present())),
                                team: Push(Team(player: Player().navigation().present())),
                                league: Push(League(
                                    team: Push(Team()),
                                    tournament: Push(Tournament(match: Push(Match())))
                                ))
                            )
                        )
                    )
                    Navigation(
                        Messages(
                            settings: Present(
                                Settings(
                                    account: Push(AccountInfo()),
                                    changePassword: Push(ChangePassword())
                                ).navigation()
                            )
                        )
                    )
                }
                .configContent({ tabbar in
                    tabbar.prepareViewAppearance()
                })
                .with(((), (), (), ()))
            }
        )
    )
```

## Installation

ScreenUI is available through [CocoaPods](https://cocoapods.org).

```ruby
pod 'ScreenUI'
```

## Author

Denis Koryttsev, @k-o-d-e-n, koden.u8800@gmail.com

## License

ScreenUI is available under the MIT license. See the LICENSE file for more info.
