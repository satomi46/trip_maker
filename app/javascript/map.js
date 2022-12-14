const map = () => {
  const apiKey = process.env.GOOGLE_MAPS_API_KEY

  // 詳細スケジュールで住所を入力したとき、座標を取得しparamsに送信
  const submit = document.getElementById("address-button");

  if (!submit) { return false; } // address-buttonがないページ（旅行詳細以外のページ）では以降の処理を行わない

  submit.addEventListener("click", (e) => {
    e.preventDefault();

    const address = document.getElementById("address").value; // フォームに入力された住所を取得
    if (address != "") {
      const url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=" + apiKey

      fetch(url, { // 入力された住所の座標等を取得
      method: "GET",
      })
      .then(response => response.json())
      .then(json => {

        const lat = json.results[0].geometry.location.lat; // APIから受け取ったjsonから緯度を取り出す
        const lng = json.results[0].geometry.location.lng; // APIから受け取ったjsonから経度を取り出す

        // 非表示でタグに値を埋めこむ（キーはlat/lng、バリューはAPIから受け取った実数）
        const latitude = `<input value=${lat} name='lat' type="hidden"> `;
        const longitude = `<input value=${lng} name='lng' type="hidden"> `;

        const coordinate = document.getElementById("coordinate")
        coordinate.insertAdjacentHTML("beforeend", latitude);
        coordinate.insertAdjacentHTML("beforeend", longitude);

        document.getElementById("detail-form").submit();
      });
    } else {
      document.getElementById("detail-form").submit();
    }
  });

  var points = [{}, {}];
  var latLng
  // 旅行詳細ページで出発地と目的地を選択してマップ表示ボタンを押すと、マップとルートを描画
  const getRouteMap = document.getElementById("get-route");
  getRouteMap.addEventListener("click", (e) => {
    e.preventDefault();

    const details = gon.details; // detailsテーブルの全レコード
    const coords = gon.coords; // coordsテーブルの全レコード

    const departurePointId = document.getElementById("title_id").value; //出発地のdetail_id
    const arrivalPointId = document.getElementById("title_title").value; // 目的地のdetail_id

    arrivalIdTarget = details.filter(function(object) { // detailsの中から、到着地のidと一致するデータを抽出
      return object.id == arrivalPointId
    }).shift();

    arrivalAddressTarget = coords.filter(function(object) { // coordsの中から、到着地のアドレスと一致するデータを抽出
      return object.address == arrivalIdTarget.address
    }).shift();

    points[1].lat = arrivalAddressTarget.latitude;
    points[1].lng = arrivalAddressTarget.longitude;

    if (departurePointId == "") { // 出発地のdetail_idが空欄のとき、つまり出発地に現在地を指定したとき
      findCurrentLocation(); // findCurrentPosition関数を呼び出し、現在地の座標をpoints[0].lat/points[0].lngに代入
    } else {
      departureIdTarget = details.filter(function(object) { // detailsの中から、出発地のidと一致するデータを抽出
        return object.id == departurePointId
      }).shift();

      departureAddressTarget = coords.filter(function(object) { // coordsの中から、出発地のアドレスと一致するデータを抽出
        return object.address == departureIdTarget.address
      }).shift();

      points[0].lat = departureAddressTarget.latitude;
      points[0].lng = departureAddressTarget.longitude;
      latLng = new google.maps.LatLng(points[0].lat, points[0].lng);

      const map = new google.maps.Map(document.getElementById("route-map-area"), { // 出発地を中心としたマップを表示
        zoom: 10,
        center: latLng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      });
      const latLngBounds = new google.maps.LatLngBounds();
      const directionService = new google.maps.DirectionsService();
      const poly = new google.maps.Polyline({strokeColor:"#FF5C61", strokeWeight:3}); // ルートの線の情報
      const request = {
        origin: new google.maps.LatLng(points[0].lat, points[0].lng),
        destination: new google.maps.LatLng(points[1].lat, points[1].lng),
        travelMode: google.maps.DirectionsTravelMode.WALKING // WALKING, BICYCLING, TRANSIT
      };

      directionService.route(request, function (response, status) {
        if (status == google.maps.DirectionsStatus.OK) {
          new google.maps.DirectionsRenderer( {
            map: map,
            polylineOptions: poly,
            directions: response
          });
        }
      });
    
      map.fitBounds(latLngBounds);
    };
  });


  function findCurrentLocation() { // 現在地を取得する関数。出発地が現在地の場合や、近隣マップを表示する場合に呼び出される。
    if (navigator.geolocation) {navigator.geolocation.getCurrentPosition(onSuccess, onError,
        {maximumAge: 60*1000,
          timeout: 5*60*1000,
          enableHighAccuracy: true});
    } else
      alert("GeolocationAPIを使用できないブラウザのためサービスをご利用できません")
  }

  function onSuccess(position) {
    points[0].lat = position.coords.latitude;
    points[0].lng = position.coords.longitude;
    latLng = new google.maps.LatLng(points[0].lat, points[0].lng);

    const map = new google.maps.Map(document.getElementById("route-map-area"), { // 出発地を中心としたマップを表示
      zoom: 10,
      center: latLng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    const latLngBounds = new google.maps.LatLngBounds();
    const directionService = new google.maps.DirectionsService();
    const poly = new google.maps.Polyline({strokeColor:"#FF5C61", strokeWeight:3}); // ルートの線の情報
    const request = {
      origin: new google.maps.LatLng(points[0].lat, points[0].lng),
      destination: new google.maps.LatLng(points[1].lat, points[1].lng),
      travelMode: google.maps.DirectionsTravelMode.WALKING // WALKING, BICYCLING, TRANSIT
    };

    directionService.route(request, function (response, status) {
      if (status == google.maps.DirectionsStatus.OK) {
        new google.maps.DirectionsRenderer( {
          map: map,
          polylineOptions: poly,
          directions: response
        });
      }
    });

        map.fitBounds(latLngBounds);
  }

  function onError(error) {
    switch(error.code) {
      case PERMISSION_DENIED:
        alert("ユーザーによりリクエストが拒否されました");
        break;
      case TIMEOUT:
        alert("要求がタイムアウトとなりました");
        break;
      case POSITION_UNAVAILABLE:
        alert("Geolocationサービスは現在ご利用できません");
        break;
      default:
        alert("不明なエラーです");
        break;
    }
  }


  // 旅行詳細ページで検索スポットと検索範囲を選択してマップ表示ボタンを押すると選択に応じた周辺マップとスポットを表示
  const getCurrentMap = document.getElementById("get-map")
  getCurrentMap.addEventListener("click", (e) => {
    e.preventDefault();

    var myLocation, spot, distance, currentMap;
    var markers = new Array();

    drawMap();

    function drawMap() {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(onSuccess, onError,
                                                  {maximumAge: 60*1000,
                                                  timeout: 5*60*1000,
                                                  enableHighAccuracy: true});
      } else
      alert("Your browser does not support Geolocation API !!!")
    }

    function onSuccess(position) {
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;
      myLocation = new google.maps.LatLng(lat, lng);

      var mapOptions = {
        center: myLocation,
        zoom: 15,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      currentMap = new google.maps.Map(document.getElementById("current-map-area"), mapOptions);

      getLocations();

      function getLocations() {
        interest = document.getElementById("map_spot").value;
        switch(interest) {
          case "病院":
            spot = "doctor"
            break;
          case "ATM":
            spot = "atm"
            break;
          case "駐車場":
            spot = "parking"
            break;
          case "図書館":
            spot = "library"
            break;
          case "レストラン":
            spot = "restaurant"
            break;
          default:
            spot = "";
            break;
        }
        distance = parseInt(document.getElementById("map_distance").value.replace(/,/g, ""), 10);
        if (spot != "") {
          findPlace();
        }
      }

      function findPlace() {
        const request = {
          location: myLocation,
          radius: distance,
          types: [spot]
        };
        const service = new google.maps.places.PlacesService(currentMap);  
        service.search(request, createMarkers);
      }

      function createMarkers(response, status) {
        const latLngBounds = new google.maps.LatLngBounds();
        if (status == google.maps.places.PlacesServiceStatus.OK) {
          clearMarkers();
          for(var i=0;i<response.length;i++) {
            drawMarker(response[i]);
            latLngBounds.extend(response[i].geometry.location);
          }
          currentMap.fitBounds(latLngBounds);
        } else
        alert("Sorry, there is some error !!!");
      }

      function drawMarker(obj) {
        var marker = new google.maps.Marker({
          position: obj.geometry.location,
          map: currentMap
        });
        markers.push(marker);

        const infoWindow = new google.maps.InfoWindow({
          content: '<img src="' + obj.icon + '"/><font style="color:gray">' +
                    obj.name + '<br />評価: ' + obj.rating +
                    '<br />住所: ' + obj.vicinity + '</font>'
        });
        google.maps.event.addListener(marker, 'click', function () {
          infoWindow.open(map, marker);
        });
      }

      function clearMarkers() {
        if (markers) {
          for(i in markers) {
            markers[i].setMap(null);
          }
          markers = [];
        }
      }
    }

  });
};

window.addEventListener("load", map);