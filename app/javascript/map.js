const map = () => {
  // 詳細スケジュールで住所を入力したとき、座標を取得しparamsに送信
  const submit = document.getElementById("address-button");
  submit.addEventListener("click", (e) => {
    e.preventDefault();

    const apiKey = process.env.GOOGLE_MAPS_API_KEY
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
};

window.addEventListener("load", map);