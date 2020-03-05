function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }

function getDataDash4() {
    let vstart = d3.select("#tripstart").property("value");
    let vend = d3.select("#tripend").property("value");
    let vgender = d3.select("#tripgender").property("value");
    arrDash4=[vstart,vend,vgender];
    console.log(arrDash4);
    //console.log(geojsonData);
    dash4(arrDash4);
  }

  let dash4=(arrDash4)=>{
    d3.json("/api/dash4", {
        method: "POST",
        body: JSON.stringify({
            varstart:arrDash4[0],
            varend:arrDash4[1],
            vargender:arrDash4[2]
        }),
        headers:{
            "Content-type":"application/json"
        }
    }).then((d)=>{
        console.log(d);
        console.log(d[0][0]);
        console.log(d[0]['estacionOrig']);
        d3.json("/static/data/estaciones-de-ecobici.geojson").then(f =>{
            //console.log(f.features);
            //console.log(f.features[1].properties.id);
            //console.log(d[1].station_begin);
            //console.log(d[1].station_end);
            var largo=d.length;
            var largogeoj=f.features.length;

            var endname=[];
            var endlat=[];
            var endlon=[];
            var avgtrips=[];
    
            for (var i = 0; i < largo; i++) {
                avgtrips.push(d[i][0]);
                for (var j=0; j< largogeoj; j++) {
                    if (f.features[j].properties.id === d[i]['estacionOrig']) {
                        endname.push(f.features[j].properties.address);
                        endlat.push(f.features[j].properties.location_lat);
                        endlon.push(f.features[j].properties.location_lon);
                    } else {
                    }
                }
            }
            console.log(endname);
            console.log(avgtrips); 
            console.log(endlat); 
            console.log(endlon); 

            for (var i = 0; i < largo; i++) {
            // Agregar rutas de cicloestación a cicloestación (parejas de quiebre)
                var coords = [
                    endlat[i],endlon[i],
                ]
                //var bikeMarker = L.icon({
                //    iconUrl: './static/data/icons8-map-pin-16.png',
                //    iconSize: [20,20]
                //});
            // Plot every line (1, 2, 3, .....)
            var station = L.marker(coords).bindPopup(`<h3>Station: ${endname[i]}</h3> <hr><h3>Avg. Trips ${Math.round(10*avgtrips[i])/10}</h3>`)
            .addTo(mymap);
            //console.log(coords);
            //var station = L.marker(coords, {icon:bikeMarker}).addTo(mymap);
        }
        })
    })
};


// Creating map object
var mymap = L.map('map', {
    center: [19.42,-99.16],
    zoom: 13
});

// Adding tile layer to the map
L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox/streets-v11',
    accessToken: API_KEY
}).addTo(mymap);

let x1 = d3.json("/static/data/estaciones-de-ecobici.geojson").then(d =>{
    //console.log(d.features);
    //console.log(d.features[1].properties.id);
// Arreglo de markes con stations (looping through the DB)
    
	
	var bikeMarker = L.icon({
		iconUrl: './static/data/bike.png',
		iconSize: [15,15]
	});
		
	var bikeStations = d.features.map(M=>{
        L.marker([M.properties.location_lat, M.properties.location_lon], {icon:bikeMarker})
        .bindPopup("<h3>" + M.properties.name + "</h3>" + "<hr>" + "<h3>" + M.properties.districtname + "</h3>", {
            maxWidth : "5px",
        }).addTo(mymap)
    })
});

let x2 = d3.json("/static/data/ciclovias.geojson").then(data =>{
    console.log(data);
	var myArray = [];
	data.features.forEach(d => {
		d.geometry.coordinates.forEach( x => {
		myArray.push([x[1], x[0]]);
		});
		L.polyline(myArray, {color: 'red'}).addTo(mymap);
		myArray = [];
	});
});

x2;


// --------------------------
// --------------------------
// ESCUCHADORES
// --------------------------
// --------------------------

d3.select("#buttondash4").on("click", getDataDash4);