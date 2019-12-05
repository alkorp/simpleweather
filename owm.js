function fmtTemp(temp) {
    return (temp - 273).toFixed() + " °C"
}
function fmtTime(date) {
    return date.toLocaleTimeString(Qt.locale(), "hh:mm")
}
function fmtDay(date) {
    return date.toLocaleDateString()
}
function fmtWindSpeed(speed) {
    return qsTr("Wind: ") + speed + qsTr(" m/s");
}

function _nextParam(key, value) {
    return "&%1=%2".arg(encodeURIComponent(key)).arg(encodeURIComponent(value))
}

function getJsonUrl(url, onDone) {
    console.log("requesting url", url)
    var request = new XMLHttpRequest()
    request.onreadystatechange = function() {
        if (request.readyState == XMLHttpRequest.DONE) {
            if (request.status && request.status === 200) {
                console.log("response", request.responseText)
                onDone(JSON.parse(request.responseText))
            } else {
                console.log("HTTP:", request.status, request.statusText)
                onDone(null)
            }
        }
    }
    request.open("GET", url);
    request.send();
}

function getCurrentWeather(city, apikey, onDone) {
    if (city.length === 0 || apikey.length === 0) return
    var url = "http://api.openweathermap.org/data/2.5/weather?"
    url += _nextParam("APPID", apikey)
    url += _nextParam("q", city)
    url += _nextParam("lang", Qt.locale().name.split("_")[0])
    getJsonUrl(url, function(json){
        if (json === null) {
            onDone(null)
        }
        var weather = json["weather"][0]
        onDone({
            "icon": Owm.iconUrl(weather.icon),
            "description": weather.description,
            "temp": fmtTemp(json.main.temp),
            "wind": fmtWindSpeed(json.wind.speed),
            "humidity": qsTr("Humidity: ") + json.main.humidity + " %",
            "pressure": qsTr("Pressure: " + json.main.pressure + qsTr(" hpa")),
        })
    })
}

function getForecast(city, apikey, listModel) {
    if (city.length == 0 || apikey.length == 0) return
    var url = "http://api.openweathermap.org/data/2.5/forecast?"
    url += _nextParam("APPID", apikey)
    url += _nextParam("q", city)
    url += _nextParam("lang", Qt.locale().name.split("_")[0])

    getJsonUrl(url, function(json){
        listModel.clear()
        if (json === null) {
            // set error
            return
        }
        for(var j=0; j<json.list.length; j++ ) {
            var item = json.list[j]
            var date = new Date(item.dt_txt)
            listModel.append({
                                 "day": fmtDay(date),
                                 "time": fmtTime(date),
                                 "icon": item.weather[0].icon,
                                 "description": item.weather[0].description,
                                 "temp": fmtTemp(item.main.temp),
                                 "wind": fmtWindSpeed(item.wind.speed),
                             })
        }
    })
}

function iconUrl(iconCode) {
    return "http://openweathermap.org/img/wn/%1@2x.png".arg(iconCode);
}

