function numberWithCommas(x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function getDataDash1() {
  let vyear_d1 = d3.select("#year_d1").property("value");
  arrDash1=[vyear_d1];
  console.log(arrDash1);
  dash1(arrDash1);
}

// --------------------------
// --------------------------
// FUNCION QUERY
// --------------------------
// --------------------------
let dash1=(arrDash1)=>{
  d3.json("/api/dash1", {
      method: "POST",
      body: JSON.stringify({
          valueYearD1: arrDash1[0]
      }),
      headers:{
          "Content-type":"application/json"
      }
  }).then((d)=>{
      console.log(d);

      let vavftime=d[1].avg_time.substr(14,2)+' m '+Math.round(10*parseFloat(d[1].avg_time.substr(17)))/10+' s';
      let vavmtime=d[0].avg_time.substr(14,2)+' m '+Math.round(10*parseFloat(d[0].avg_time.substr(17)))/10+' s';

      d3.select("#m_bikers").text(numberWithCommas(d[1].numero_usuarios));
      d3.select("#m_age").text(Math.round(d[1].avg_edad*10)/10);
      d3.select("#m_avgtrips").text(numberWithCommas(Math.round(d[1].avg_usuarios)));
      d3.select("#m_avgtriptime").text(vavmtime);

      d3.select("#f_bikers").text(numberWithCommas(d[0].numero_usuarios));
      d3.select("#f_age").text(Math.round(d[0].avg_edad*10)/10);
      d3.select("#f_avgtrips").text(numberWithCommas(Math.round(d[0].avg_usuarios)));
      d3.select("#f_avgtriptime").text(vavftime);
  })
};

// --------------------------
// --------------------------
// ESCUCHADORES
// --------------------------
// --------------------------

d3.select("#buttondash1").on("click", getDataDash1);



