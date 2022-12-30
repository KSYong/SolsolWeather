
# ERIC'S WEATHER APP

</br>

## 프로젝트 소개

</br>

UIKit으로 구현해 보았던 날씨 앱을 SwiftUI로 다시 구현해 보는 프로젝트 입니다.

또한 API를 통한 날씨 정보 획득을 위한 방식을 Openweather API가 아닌 Apple WeatherKit으로 바꾸고, MapKit을 통한 도시 탐색 등의 추가적인 기능도 구현해 보면서 사용자 앱 경험을 향상시키는 것이 목표입니다.

* 개발자 : 권승용 [https://github.com/KSYong]

</br>

## 개발 환경 및 라이브러리

* **Xcode 14**  
    * WeatherKit은 iOS 16.0 버전부터 지원하기 때문에, 해당 버전을 지원하는 Xcode 14를 사용하였습니다.
    
* **SwiftUI**
    * State 기반 UI 방식에 매력을 느껴 SwiftUI를 사용해 보았습니다.
* **라이브러리 및 프레임워크**
    * 날씨 정보를 받아오기 위해 Apple WeatherKit을 사용하였습니다. 

</br>

## 핵심 경험

* **MVVM 패턴에 대한 이해**
    * SwiftUI의 Combine을 사용한 데이터 바인딩을 통해 MVVM 패턴을 적용해 보았습니다.

* **MKLocationSearchCompletion을 이용한 도시 검색 자동완성 구현**
    *  이전 앱에서는 도시 검색 기능을 구현하기 위해 미리 작성한 도시 리스트를 저장해서 사용했습니다. 따라서 미리 작성하지 않은 도시는 검색할 수 없다는 단점이 있었습니다.
    * 이를 개선하기 위해 MapKit에서 제공하는 MKLocationSearchCompletion을 사용해 도시 검색 자동완성 기능을 구현하였습니다.

* **WeatherKit을 통한 날씨 정보 가져오기**
    * 날씨 정보를 가져오기 위해 애플에서 제공하는 WeatherKit을 사용해 보았습니다.
    * Openweather API에 비해 호출 가능 횟수가 높고, 더 다양한 정보를 제공하기 때문에 사용해 보고자 하였습니다.

</br>

## 폴더 구조

```
📦WeatherApp_SwiftUI_Refactoring  
 ┣ 📂Application  
 ┃ ┣ 📜MainView.swift  
 ┃ ┗ 📜WeatherApp_SwiftUI_RefactoringApp.swift  
 ┣ 📂Assets.xcassets  
 ┃ ┣ 📂AccentColor.colorset  
 ┃ ┃ ┗ 📜Contents.json  
 ┃ ┣ 📂AppIcon.appiconset  
 ┃ ┃ ┣ 📜AppIcon.png  
 ┃ ┃ ┗ 📜Contents.json  
 ┃ ┣ 📂Colors  
 ┃ ┃ ┣ 📂FontColor.colorset  
 ┃ ┃ ┃ ┗ 📜Contents.json  
 ┃ ┃ ┗ 📜Contents.json  
 ┃ ┗ 📜Contents.json  
 ┣ 📂Model  // 모델
 ┃ ┗ 📜Weather.swift  // 날씨 모델 
 ┣ 📂Preview Content  
 ┃ ┗ 📂Preview Assets.xcassets  
 ┃ ┃ ┗ 📜Contents.json  
 ┣ 📂View  // 뷰
 ┃ ┣ 📂Components  
 ┃ ┃ ┗ 📜MapComponent.swift  // 애플 지도 컴포넌트를 담은 뷰
 ┃ ┣ 📂Home  
 ┃ ┃ ┗ 📜HomeView.swift  // 메인 화면
 ┃ ┣ 📂Search  
 ┃ ┃ ┗ 📜SearchView.swift  // 도시 탐색 화면
 ┃ ┗ 📂Settings  
 ┃ ┃ ┗ 📜SettingsView.swift  // 설정 화면
 ┣ 📂ViewModel  // 뷰모델
 ┃ ┣ 📜LocationViewModel.swift  // 위치 정보 관련 작업을 처리하는 뷰모델
 ┃ ┣ 📜SearchViewModel.swift  // 도시 검색 관련 작업을 처리하는 뷰모델 
 ┃ ┗ 📜WeatherViewModel.swift  // 날씨 정보 관련 작업을 처리하는 뷰모델
 ┗ 📜WeatherApp_SwiftUI_Refactoring.entitlements
```


</br>

## 문제 및 해결 과정

</br>

* ### 처음 뷰 로딩 시 날씨 정보 동기화가 되지 않고, 두번째 뷰 로딩부터 동기화가 되는 문제
   * 문제 발생 이유
        -   CoreLocation을 통해 현재 위치를 가져오고, WeatherKit을 통해 현재 위치에 대한 날씨 정보를 받아오는 코드를 작성하였다.
		-   이 때, 날씨 정보는 비동기적으로 받아오게 된다. 따라서 해당 날씨 정보를 observable object로 선언한 뷰모델 내부의 @Published 변수에 담기게 하고, 뷰에서는 해당 변수 내용을 텍스트로 표시하게 하였다고 생각했다.
		-   그러나 실제로는 뷰모델의 변수를 바인딩한 것이 아니고, 홈 뷰에서 새로운 날씨 변수를 따로 만들어, onAppear 시에 뷰모델에서 가져온 날씨 정보를 담아 보여준 것이었다.
		-   그렇기 때문에 첫 로딩 시에는 아직 날씨 정보는 비동기적으로 받아오고 있는 중이기 때문에, 뷰 내부의 날씨 정보 변수에는 아무런 정보도 받아오지 못했을 것이고
		-   다른 뷰로 이동 후, 다시 홈 뷰로 돌아왔을 때 onAppear가 실행되면, 비동기적 실행이 완료된 weather 정보를 받을 수 있게 되어, 뷰에 정상적으로 표기되는 것이었다.
    * 문제 해결 방법
		* 날씨 정보를 보여주는 Text 뷰에서 보여줄 변수를 홈 뷰 내부의 변수가 아닌, 뷰모델의 @Published 변수로 변경해 주어서 뷰모델의 변수가 바뀌는 순간 Text뷰도 리로드 되어 실시간 동기화가 이루어질 수 있도록 하였다. 
		```swift
		// 이전
		@State private var weather: Weather = Weather(temperature: 0, condition: "", symbolName: "", minTemperature: "", maxTemperature: "")
		
		...
		
		var body: some View {
		
		...
		
			Text("최저 : \(weather.minTemperature)°")
			    .font(.system(size:20, weight: .medium))
			    .foregroundColor(.white)
			    .shadow(radius: 1)
			Text("최고 : \(weather.maxTemperature)°")
			    .font(.system(size:20, weight: .medium))
			    .foregroundColor(.white)
			    .shadow(radius: 1)
		...
		
		}

		// 이후
		...

		var body: some View {

		@EnvironmentObject var weatherViewModel: WeatherViewModel

		...

			Text("최저 : \(weatherViewModel.currentWeather.minTemperature)°")
			    .font(.system(size:20, weight: .medium))
			    .foregroundColor(.white)
			    .shadow(radius: 1)
			Text("최고 : \(weatherViewModel.currentWeather.maxTemperature)°")
			    .font(.system(size:20, weight: .medium))
			    .foregroundColor(.white)
			    .shadow(radius: 1) 

		...
		}
* ### CoreLocation으로부터 현재 위치가 받아와지기 이전에 현재 위치를 담을 변수에 접근하는 문제
  * 문제 발생 이유
    -   현재 위치의 날씨 정보를 받아오는 함수가 HomeView 내의 .task 모디파이어로부터 실행된다.
	-   문제는 앱 실행 시 현재 위치를 받아오기 전에 .task 내부의 날씨 정보를 받아오는 함수가 실행되는 것
		```swift
		.task { if locationViewModel.currentLocation != nil { await weatherViewModel.getWeatherFromLocation(currentLocation: locationViewModel.currentLocation!) } }
  * 문제 해결 방법
    * 첫 번째 시도

		-   currentLocation 변수가 할당되는 순간은 CLLocationDelegate의 `locationManager(_ manager: didUpdateLocations:)`함수 내부에 있다.
    
		    ```swift
		    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		        guard let location = locations.last, currentLocation == nil else {
		            return
		        }
		        
		        DispatchQueue.main.async {
		    				// 여기서 currentLocation을 저장하게 된다.
		            self.currentLocation = location
		            self.setPlaceName(for: location)
		            
		        }
		    }
		    
		    ```
    
		-   그렇다면 날씨를 받아오는 함수를 currentLocation 할당 후 곧바로 실행해 보는 것은 어떨까?
		    
		    ```swift
		    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		        guard let location = locations.last, currentLocation == nil else {
		            return
		        }
		        
		        DispatchQueue.main.async {
		    				// 여기서 currentLocation을 저장하게 된다.
		            self.currentLocation = location
		            self.setPlaceName(for: location)
		            
		    				// <- 여기서 currentLocation을 기반으로 weatherViewModel 인스턴스에 값을 저장해 볼까?
		    
		        }
		    }
		    
		    ```
    
		-   이는 뷰모델에서 다른 뷰모델의 EnvironmentObject에 접근해야 한다는 문제점이 있다. 뷰모델 간의 의존성이 생기게 되고, 코드를 복잡하게 만든다.
    

	*  더 좋은 방법

		-   .onChange 모디파이어를 사용해, currentLocation: CLLocation? 값에 변화가 있을 경우 날씨를 불러오는 함수를 실행하게 한다.
		    
		    ```swift
		    .onChange(of: locationViewModel.currentLocation, perform: { newValue in
		    	// 현재 위치 정보가 받아와졌을 때만 
		    	if locationViewModel.currentLocation != nil {
		    			// 동기적 함수 내의 비동기적 함수 실행을 위한 Task 선언
		          Task {
		    					// 날씨 불러오기
		              await weatherViewModel.getWeatherFromLocation(currentLocation: locationViewModel.currentLocation!)
		          }
		      }
		    })
		    
		    ```
		    
		-   currentLocation이 @EnvironmentObject로 구독 중인 LocationViewModel의 @Published 프로퍼티이기 때문에, 해당 요소가 변경되는 것을 뷰에서 알 수 있다. 따라서 .onChanged를 사용 가능하다.
		    
		-   또한 추후 도시를 선택해서 날씨를 보여주는 기능도 추가할 것인데, 이 때에도 currentLocation에 선택한 도시 위치를 업데이트 하게 되면 자동으로 날씨를 불러와지게 되기 때문에 코드의 효율성이 올라간다.



</br>

## Commit Convention

커밋 컨벤션은 Udacity Git Commit Message Style Guide 를 따릅니다.

* feat: A new feature
* fix: A bug fix
* docs: Changes to documentation
* style: Formatting, missing semi colons, etc; no code change
* refactor: Refactoring production code
* test: Adding tests, refactoring test; no production code change
* chore: Updating build tasks, package manager configs, etc; no production code change
