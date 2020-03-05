var latlngs = [
    [-99.173317125359, 19.3911386405134], 
	[-99.172137821668, 19.390858164052702], 
	[-99.1712748258699, 19.3906581144002], 
	[-99.1704938063714, 19.3904769830705],
	[-99.1698398158328, 19.3903253455841], [-99.1691554800425, 19.3901666712277], 
	[-99.1685856489123, 19.390034543404], [-99.1680540341353, 19.389911273506], 
	[-99.1667398588484, 19.3896221194278], [-99.1665057556204, 19.3895706092381], 
	[-99.1657365257123, 19.3894013582872], [-99.1650261911414, 19.3892450573106], 
	[-99.1643193436077, 19.389089515426], [-99.163585614955, 19.3889280639365], 
	[-99.1631652711959, 19.3888331953951], [-99.1628000506836, 19.3887517965698], 
	[-99.162112581526, 19.3885996162858], [-99.1615891555958, 19.3884839793306], 
	[-99.1611504410559, 19.3883866507811], [-99.1605920411185, 19.3882602927106], 
	[-99.1599051475808, 19.3881110112428], [-99.1591773469317, 19.3879499615612], [-99.1584590909969, 19.3877909403995], 
	[-99.1577070136924, 19.3876244289179], [-99.1568485925413, 19.3874271158541], 
	[-99.1560986792197, 19.3872547400988], [-99.1560786574239, 19.3872501446192], 
	[-99.1553672995507, 19.3870861578161], [-99.1546372303556, 19.3869188072443], [-99.1544379818826, 19.3868738866334], 
	[-99.1539618406002, 19.3867689724941], [-99.1533532163414, 19.3866378174183], [-99.1527091380787, 19.3864990218808], 
	[-99.1519907807456, 19.3863421140655], [-99.1510202347484, 19.3862222959025], [-99.1503628650445, 19.3861441904593], 
	[-99.1497242613894, 19.3860683070038], [-99.1489007351333, 19.3859734512605], [-99.1472601723119, 19.3857754939778], 
	[-99.1465745097491, 19.3856843927997], [-99.1464093622664, 19.3856632807041], [-99.1455813689285, 19.3855524290677], 
	[-99.1449264307016, 19.3854654040872], [-99.1447046075993, 19.3854359283308], [-99.1434459688131, 19.3852218419606], 
	[-99.1429605753667, 19.3851392972767], [-99.1423392221292, 19.3850336093499], [-99.1419074482223, 19.3849601641087], 
	[-99.1414704701291, 19.384885839648], [-99.1413243723527, 19.3848609920555], [-99.1410266581054, 19.3848103482996], 
	[-99.1405231380883, 19.3847246923416], [-99.1394290458261, 19.3845136860529]
	];
	
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }

function getDataDash3() {
    let vdisagg = d3.select("#disagg").property("value");
    arrDash3=[vdisagg];
    console.log(arrDash3);
    //console.log(geojsonData);
    dash3(arrDash3);
  }

  let dash3=(arrDash3)=>{
    d3.json("/api/dash3", {
        method: "POST",
        body: JSON.stringify({
            valueDisagg: arrDash3[0]
        }),
        headers:{
            "Content-type":"application/json"
        }
    }).then((d)=>{
        //console.log(d);
        d3.json("/static/data/estaciones-de-ecobici.geojson").then(f =>{
            //console.log(f.features);
            //console.log(f.features[1].properties.id);
            //console.log(d[1].station_begin);
            //console.log(d[1].station_end);
            var largo=d.length;
            var largogeoj=f.features.length;

            var startname=[];
            var startlat=[];
            var startlon=[];
            var endname=[];
            var endlat=[];
            var endlon=[];
            var trips=[];
            var time=[];
    
            for (var i = 0; i < largo; i++) {
                time.push(d[i].triptime);
                trips.push(d[i].tot);
                for (var j=0; j< largogeoj; j++) {
                    if (f.features[j].properties.id === d[i].station_begin) {
                        //console.log('begin');
                        //console.log(f.features[1].properties.id);
                        //console.log(d[1].station_begin); 
                        startname.push(f.features[j].properties.address);
                        startlat.push(f.features[j].properties.location_lat);
                        startlon.push(f.features[j].properties.location_lon);
                    } else if (f.features[j].properties.id === d[i].station_end) {
                        //console.log('end');
                        //console.log(f.features[1].properties.id);
                        //console.log(d[1].station_end); 
                        endname.push(f.features[j].properties.address);
                        endlat.push(f.features[j].properties.location_lat);
                        endlon.push(f.features[j].properties.location_lon);
                    } else {
                    }
                }
            }
            //console.log(startname);
            //console.log(time);
            //console.log(endname); 
            for (var i = 0; i < largo; i++) {
            // Agregar rutas de cicloestación a cicloestación (parejas de quiebre)
            var line = [
                [startlat[i],startlon[i]],
                [endlat[i],endlon[i]],
            ]
            var avgtime=time[i].substr(14,2)+' m '+Math.round(10*parseFloat(time[i].substr(17)))/10+' s';
            // Plot every line (1, 2, 3, .....)
            var polyline = L.polyline(line, {
                color: "green"
            }).bindPopup(`<h3>Start: ${startname[i]}</h3> <h3>End: ${endname[i]}</h3> <hr><h3>Trips ${numberWithCommas(trips[i])}</h3> <h3>Avg. time ${avgtime}</h3>`)
            .addTo(mymap);
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


x1;
x2;

d3.select("#buttondash3").on("click", getDataDash3);
