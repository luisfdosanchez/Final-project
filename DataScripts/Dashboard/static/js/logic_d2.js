function getDataDash2() {
  let vgtype = d3.select("#gtype").property("value");
  let vdisagg = d3.select("#disagg").property("value");
  arrDash2=[vgtype,vdisagg];
  console.log(arrDash2);
  dash2(arrDash2);
}

// --------------------------
// --------------------------
// FUNCION QUERY
// --------------------------
// --------------------------
let dash2=(arrDash2)=>{
    d3.json("/api/dash2", {
        method: "POST",
        body: JSON.stringify({
            valueGtype: arrDash2[0],
            valueDisagg: arrDash2[1]
        }),
        headers:{
            "Content-type":"application/json"
        }
    }).then((d)=>{
        console.log(d);
        var largo=d.length;
        if (arrDash2[0]=="daily" || arrDash2[0]=="monthly" || arrDash2[0]=="yearly") {
          var ttitle="Trips";
          var tyaxis="Total trips";
        } else {
          var ttitle="Average daily trips";
          var tyaxis="Avg. trips";
        }
        if (arrDash2[1]==="time") {
          var xvar = [];
          var yvar1 = [];
          var yvar2 = [];
          var yvar3 = [];
          var yvar4 = [];
          for (var i = 0; i < largo; i++) {
              xvar.push(d[i].ddate);
              yvar1.push(d[i].tot_beg);
              yvar2.push(d[i].tot_mor);
              yvar3.push(d[i].tot_aft);
              yvar4.push(d[i].tot_eve);
              //console.log(d[i].count);
          }
          var traces = [
            {x: xvar, y: yvar1, type:'bar', name:'Beginning of day (12:00am - 05:59am)'},
            {x: xvar, y: yvar2, type:'bar', name:'Morning (06:00am - 11:59am)'},
            {x: xvar, y: yvar3, type:'bar', name:'Afternoon (12:00pm - 05:59pm)'},
            {x: xvar, y: yvar4, type:'bar', name:'Evening (06:00pm - 11:59pm)'}
          ];
          var layout = {
            title: {text:ttitle+' by time of day', font: {size: 24}},
            yaxis: {title: {text: tyaxis,font: {size: 12}}},
            legend: { xanchor:"center", yanchor:"bottom", "orientation": "h", x:0.5, y:0.96},
            barmode: 'stack'
          };
          Plotly.newPlot('plot', traces, layout);
        } else if (arrDash2[1]==="gender") {
          var xvar = [];
          var yvar1 = [];
          var yvar2 = [];
          for (var i = 0; i < largo; i++) {
              xvar.push(d[i].ddate);
              yvar1.push(d[i].tot_fem);
              yvar2.push(d[i].tot_masc);
              //console.log(d[i].count);
          }
          var traces = [
            {x: xvar, y: yvar1, type:'bar', name:'Female'},
            {x: xvar, y: yvar2, type:'bar', name:'Male'},
          ];
          var layout = {
            title: {text:ttitle+' by gender', font: {size: 24}},
            yaxis: {title: {text: tyaxis,font: {size: 12}}},
            legend: { xanchor:"center", yanchor:"bottom", "orientation": "h", x:0.5, y:0.96},
            barmode: 'stack'
          };
          Plotly.newPlot('plot', traces, layout);
        } else if (arrDash2[1]==="length") {
          var xvar = [];
          var yvar1 = [];
          var yvar2 = [];
          var yvar3 = [];
          var yvar4 = [];
          for (var i = 0; i < largo; i++) {
              xvar.push(d[i].ddate);
              yvar1.push(d[i].tot_zeroten);
              yvar2.push(d[i].tot_tentwenty);
              yvar3.push(d[i].tot_tewntythirty);
              yvar4.push(d[i].tot_thritymore);
              //console.log(d[i].count);
          }
          var traces = [
            {x: xvar, y: yvar1, type:'bar', name:'0min0sec - 9min59sec'},
            {x: xvar, y: yvar2, type:'bar', name:'10min0sec - 19min59sec'},
            {x: xvar, y: yvar3, type:'bar', name:'20min0sec - 29min59sec'},
            {x: xvar, y: yvar4, type:'bar', name:'30min0sec & over'}
          ];
          var layout = {
            title: {text:ttitle+' by trip length', font: {size: 24}},
            yaxis: {title: {text: tyaxis,font: {size: 12}}},
            legend: { xanchor:"center", yanchor:"bottom", "orientation": "h", x:0.5, y:0.96},
            barmode: 'stack'
          };
          Plotly.newPlot('plot', traces, layout);
        } else if (arrDash2[1]==="age") {
          var xvar = [];
          var yvar1 = [];
          var yvar2 = [];
          var yvar3 = [];
          var yvar4 = [];
          for (var i = 0; i < largo; i++) {
              xvar.push(d[i].ddate);
              yvar1.push(d[i].tot_you);
              yvar2.push(d[i].tot_mid);
              yvar3.push(d[i].tot_old);
              yvar4.push(d[i].tot_eld);
              //console.log(d[i].count);
          }
          var traces = [
            {x: xvar, y: yvar1, type:'bar', name:'0-25 yrs'},
            {x: xvar, y: yvar2, type:'bar', name:'26-35 yrs'},
            {x: xvar, y: yvar3, type:'bar', name:'36-45 yrs'},
            {x: xvar, y: yvar4, type:'bar', name:'46 yrs and over'}
          ];
          var layout = {
            title: {text:ttitle+' age group', font: {size: 24}},
            yaxis: {title: {text: tyaxis,font: {size: 12}}},
            legend: { xanchor:"center", yanchor:"bottom", "orientation": "h", x:0.5, y:0.96},
            barmode: 'stack'
          };
          Plotly.newPlot('plot', traces, layout);
        } else if (arrDash2[1]==="all") {
          var xvar = [];
          var yvar1 = [];
          for (var i = 0; i < largo; i++) {
              xvar.push(d[i].ddate);
              yvar1.push(d[i].count);
              //console.log(d[i].count);
          }
          var traces = [
            {x: xvar, y: yvar1, type:'bar', name:'Total'},
          ];
          var layout = {
            title: {text:ttitle, font: {size: 24}},
            yaxis: {title: {text: tyaxis,font: {size: 12}}},
            legend: { xanchor:"center", yanchor:"bottom", "orientation": "h", x:0.5, y:0.96},
            barmode: 'stack'
          };
          Plotly.newPlot('plot', traces, layout);
        }
    })
};
// --------------------------
// --------------------------
// ESCUCHADORES
// --------------------------
// --------------------------

d3.select("#buttondash2").on("click", getDataDash2);



