const map = () => {
  const apiKey = process.env.GOOGLE_MAPS_API_KEY

  // 詳細スケジュールで住所を入力したとき、座標を取得しparamsに送信
  const submit = document.getElementById("address-button");
  submit.addEventListener("click", (e) => {
    e.preventDefault();

    const address = document.getElementById("address").value; // フォームに入力された住所を取得
    const xmlHttpAddress = new XMLHttpRequest();
    const url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=" + apiKey
    xmlHttpAddress.open("GET", url, false);
    xmlHttpAddress.send(); // APIへ住所を投げる

    if (xmlHttpAddress.readyState == 4 && xmlHttpAddress.status == 200) { // APIからのレスポンスを確認
      const result = xmlHttpAddress.responseText;
      const jsResult = eval("(" + result + ")");

      const lat = jsResult.results[0].geometry.location.lat; // APIから受け取った緯度
      const lng = jsResult.results[0].geometry.location.lng; // APIから受け取った経度

      // 非表示でタグに値を埋めこむ（キーはlat/lng、バリューはAPIから受け取った実数）
      const latitude = `<input value=${lat} name='lat' type="hidden"> `;
      const longitude = `<input value=${lng} name='lng' type="hidden"> `;

      const coordinate = document.getElementById("coordinate")
      coordinate.insertAdjacentHTML("beforeend", latitude);
      coordinate.insertAdjacentHTML("beforeend", longitude);
    }

    document.getElementById("detail-form").submit();
  });


  // 旅行詳細ページで出発地と目的地を選択してマップ表示ボタンを押すと、マップとルートを描画
  const getRouteMap = document.getElementById("get-route");
  getRouteMap.addEventListener("click", (e) => {
    e.preventDefault();

    const points = [{}, {}];
    const details = gon.details; // detailsテーブルの全レコード
    const coords = gon.coords; // coordsテーブルの全レコード

    const departurePointId = document.getElementById("title_id").value; //出発地のdetail_id
    const arrivalPointId = document.getElementById("title_title").value; // 目的地のdetail_id

    departureIdTarget = details.filter(function(object) { // detailsの中から、出発地のidと一致するデータを抽出
      return object.id == departurePointId
    }).shift();

    departureAddressTarget = coords.filter(function(object) { // coordsの中から、出発地のアドレスと一致するデータを抽出
      return object.address == departureIdTarget.address
    }).shift();

    arrivalIdTarget = details.filter(function(object) { // detailsの中から、出発地のidと一致するデータを抽出
      return object.id == arrivalPointId
    }).shift();

    arrivalAddressTarget = coords.filter(function(object) { // coordsの中から、出発地のアドレスと一致するデータを抽出
      return object.address == arrivalIdTarget.address
    }).shift();

    points[0].lat = departureAddressTarget.latitude;
    points[0].lng = departureAddressTarget.longitude;
    points[1].lat = arrivalAddressTarget.latitude;
    points[1].lng = arrivalAddressTarget.longitude;

    // const url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + arrivalAddressTarget.address + "&key=" + apiKey
    // fetch(url, { // 3時間ごとのデータを取得
    //   method: "GET",
    // })
    // .then(response => response.json())
    // .then(json => {
    //   console.log(json.results[0].geometry.location)
    // })


    const latLng = new google.maps.LatLng(points[0].lat, points[0].lng);
    const map = new google.maps.Map(document.getElementById("route-map-area"), { // 出発地を中心としたマップを表示
      zoom: 10,
      center: latLng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    const latLngBounds = new google.maps.LatLngBounds();

    for( var i=0; i<points.length; i++) { // 地図に2地点のマーカーをそれぞれ立てる
      var marker = new google.maps.Marker({
        position: new google.maps.LatLng(points[i].lat, points[i].lng),
        map: map
      })
      latLngBounds.extend(marker.position);
    }

    map.fitBounds(latLngBounds);


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

  });
};

window.addEventListener("load", map);