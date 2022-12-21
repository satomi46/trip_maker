const weather = () => {
  // 詳細スケジュールで天候データ取得ボタンをクリックしたとき、座標から天候情報を取得し表示する
  const weatherLoadButtons = document.querySelectorAll(".weather-load-button");
  weatherLoadButtons.forEach(function (button) { // weatherLoadButtonsの要素一つ一つをbuttonとして扱う
    button.addEventListener("click", (e) => {
      e.preventDefault();

      const coords = gon.coords // coordsテーブルのデータ
      const apiKey = process.env.OPEN_WEATHER_API_KEY
      const targetAddress = button.getAttribute("data"); // 目的の住所
      const detailId = button.getAttribute("data2"); // 目的の住所

      target = coords.filter(function(object) { // coordsの中から、targetと住所が一致するデータを取得（lat, lngつき）
        return object.address == targetAddress
      }).shift()

      const latitude = target.latitude;
      const longitude = target.longitude;

      const hourlyUrl = "https://api.openweathermap.org/data/2.5/forecast?lat=" + latitude + "&lon=" + longitude + "&cnt=6&units=metric&lang=ja&APPID=" + apiKey;
      // 3時間ごと、6回分(cnt=6)のデータを取得。気温は摂氏指定(units=metric)
      const dailyUrl = "https://api.openweathermap.org/data/3.0/onecall?lat=" + latitude + "&lon=" + longitude + "&exclude=minutely,hourly,alerts,&units=metric&lang=ja&APPID=" + apiKey;
      // 1日ごとのデータ取得

      fetch(hourlyUrl, { // 3時間ごとのデータを取得
        method: "GET",
      })
      .then(response => response.json())
      .then(json => {

        for (let i = 0; i < 6; i++) { // 3時間ごとの天気を6件表示
          if (document.getElementById("weather-" + detailId).innerHTML == "天気更新") { // 天気を一度取得していた場合、まず元のデータを削除
            document.getElementById("hourly-time-" + detailId + "-" + i).innerText = ""
            document.getElementById("hourly-icon-" + detailId + "-" + i).innerText = ""
            document.getElementById("hourly-temperature-" + detailId + "-" + i).innerText = ""
          }
          const date = new Date(json.list[i].dt * 1000); // 1970/1/1基準で経過ミリ秒を現在の日本時間基準に
          const month = date.getMonth() + 1; // 0〜11で値が返るため1を足す
          const dayTime = month + "/" + date.getDate() + " " + date.getHours() + ":00";
          const dayTimeArea = document.getElementById("hourly-time-" + detailId + "-" + i)
          dayTimeArea.insertAdjacentText("afterbegin", dayTime)

          const icon = json.list[i].weather[0].icon
          const iconImg = document.createElement("img");
          iconImg.src = "http://openweathermap.org/img/w/" + icon + ".png";
          iconImg.alt = "天候アイコン"
          iconImg.height = 50;
          iconImg.width = 50;
          const hourlyIcon = document.getElementById("hourly-icon-" + detailId + "-" + i)
          hourlyIcon.appendChild(iconImg);

          const hourlyTemperature = json.list[i].main.temp.toFixed()
          const hourlyTemperatureArea = document.getElementById("hourly-temperature-" + detailId + "-" + i)
          hourlyTemperatureArea.insertAdjacentText("afterbegin", hourlyTemperature + "℃")
        }
      });


      fetch(dailyUrl, { // 日ごとのデータを取得
        method: "GET",
      })
      .then(response => response.json())
      .then(json => {
        
        for (let i = 0; i < 3; i++) { // 日ごと天気を3件表示
          if (document.getElementById("weather-" + detailId).innerHTML == "天気更新") { // 天気を一度取得していた場合、まず元のデータを削除
            document.getElementById("day-" + detailId + "-" + i).innerText = ""
            document.getElementById("daily-icon-" + detailId + "-" + i).innerText = ""
            document.getElementById("daily-high-temperature-" + detailId + "-" + i).innerText = ""
            document.getElementById("daily-low-temperature-" + detailId + "-" + i).innerText = ""
            document.getElementById("daily-sunrise-" + detailId + "-" + i).innerText = ""
            document.getElementById("daily-sunset-" + detailId + "-" + i).innerText = ""
          }

          const date = new Date(json.daily[i].dt * 1000); // 1970/1/1基準で経過ミリ秒を現在の日本時間基準に(9時間のoffset済み)
            const month = date.getMonth() + 1; // 0〜11で値が返るため1を足す
            const day = month + "/" + date.getDate();
            const dayArea = document.getElementById("day-" + detailId + "-" + i)
            dayArea.insertAdjacentText("afterbegin", day)

            const icon = json.daily[i].weather[0].icon
            const iconImg = document.createElement("img");
            iconImg.src = "http://openweathermap.org/img/w/" + icon + ".png";
            iconImg.alt = "天候アイコン"
            iconImg.height = 50;
            iconImg.width = 50;
            const dailyIcon = document.getElementById("daily-icon-" + detailId + "-" + i)
            dailyIcon.appendChild(iconImg);

            const dailyHighTemperature = json.daily[i].temp.max.toFixed()
            const dailyLowTemperature = json.daily[i].temp.min.toFixed()
            const dailyHighTemperatureArea = document.getElementById("daily-high-temperature-" + detailId + "-" + i)
            dailyHighTemperatureArea.insertAdjacentText("afterbegin", dailyHighTemperature + "℃")
            const dailyLowTemperatureArea = document.getElementById("daily-low-temperature-" + detailId + "-" + i)
            dailyLowTemperatureArea.insertAdjacentText("afterbegin", dailyLowTemperature + "℃")

            const sunrise = new Date(json.daily[i].sunrise * 1000);
            let sunriseTime = sunrise.getHours() + ":" + sunrise.getMinutes();
            if (sunrise.getMinutes() < 10) {
            sunriseTime = sunrise.getHours() + ":0" + sunrise.getMinutes();
            }
            const sunset = new Date(json.daily[i].sunset * 1000);
            let sunsetTime = sunset.getHours() + ":" + sunset.getMinutes();
            if (sunset.getMinutes() < 10) {
              sunsetTime = sunset.getHours() + ":0" + sunset.getMinutes();
            }
            const sunriseTimeArea = document.getElementById("daily-sunrise-" + detailId + "-" + i)
            sunriseTimeArea.insertAdjacentText("afterbegin", "↗︎ " + sunriseTime)
            const sunsetTimeArea = document.getElementById("daily-sunset-" + detailId + "-" + i)
            sunsetTimeArea.insertAdjacentText("afterbegin", "↘︎ " + sunsetTime)
        }
      });

        // ボタンを「天気更新」に変更
        document.getElementById("weather-" + detailId).innerHTML = "天気更新"
    }
  )})
};

window.addEventListener("load", weather);