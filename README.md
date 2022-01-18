# GXInject

## Простая обертка для DI.

# 🔷 Требования

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Xcode 11.0  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Swift 5+  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ iOS 13 

# 🔷 Установка

`GXInject` доступен через [Swift Package Manager](https://swift.org/package-manager).

Используя Xcode 11 и выше, нужно зайти в  `File -> Swift Packages -> Add Package Dependency` ввести адрес репозитория. 
Выбираем последнюю версию по тегу, ждем синхронизации, вуаля, можно использовать утилитки) 
При обновлении утилит, можно воспользоваться `File -> Swift Packages -> Update to Latest packages versions`

# 🔷 Documentation

0) Создайте протоколы и имплементации

``` swift
protocol HomeAPIManagerProtocol {
    func getAlcoDrinks(endpoint: APICall) -> AnyPublisher<AlcoDrinkList, Error>
    
    func getCategories(endpoint: APICall) -> AnyPublisher<AlcoCategories, Error>
}

class HomeAPIManager: HomeAPIManagerProtocol {
    ...
    
    func getAlcoDrinks(endpoint: APICall) -> AnyPublisher<AlcoDrinkList, Error> {
        ...
    }
    
    func getCategories(endpoint: APICall) -> AnyPublisher<AlcoCategories, Error> {
        ...
    }
}
```


1) Зарегиструйте свои зависимости с нужной вам имплементацией, например, таким способом
``` swift
 // MARK: - register DI
extension AppDelegate {
    
    private func registerDataServices() -> [Dependency] {
        DependencyBuilder.buildBlock(
            Dependency { HomeAPIManager() },
            Dependency { HomeDBManager() }
        )
    }
}
```

2) В нужном месте соберите свои зависимости. Например, так
```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch. 
        let dependencies = Dependencies {
            registerDataServices()
            registerOnboarding()
            registerLoginServices()
            registerHome()
        }
        // Resolve only when it's needed
        dependencies.build()
    
        return true
    }
```

3) Используйте @Injected для вызова вашей зависимости!
```swift
class HomeInteracor {
    
    @Injected var homeAPIManager: HomeAPIManagerProtocol
    ....

}
```