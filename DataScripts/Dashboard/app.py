from flask import Flask, jsonify, request, render_template, Response
import psycopg2
import pandas as pd
from sqlalchemy import create_engine
from postgreSQLpassword import passW
import numpy as np
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.models import load_model

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/dash1")
def dashB1():
    return render_template("dashboard1.html")

@app.route("/dash2")
def dashB2():
    return render_template("dashboard2.html")

@app.route("/dash3")
def dashB3():
    return render_template("dashboard3.html")

@app.route("/dash4")
def dashB4():
    return render_template("dashboard4.html")

@app.route("/contacts")
def contacts():
    return render_template("contacts.html")



@app.route("/api/dash1", methods=["POST"])
def dash1():
    miRequest = request.json

    varYrD1 = int(miRequest["valueYearD1"])

    conn = psycopg2.connect(database="newecobici",user="postgres", password=passW, host ="localhost",port="5432")
    cursor=conn.cursor()
    try:
        print("table not created0!")
        cursor.execute(f'CREATE TABLE dash1_{varYrD1} (ID SERIAL PRIMARY_KEY, genero_usuario VARCHAR, numero_usuarios NUMERIC, avg_edad NUMERIC, avg_time INTERVAL, avg_usuarios NUMERIC);')
        print("table not created1!")
        df=pd.read_sql_query(f'with mes as(select genero_usuario,mes_retiro,count(genero_usuario) as numero_usuarios,avg(edad_usuario) as edad_promedio,AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS avgtime from ecobicidf where anio_retiro in ({varYrD1}) group by 1,2) select genero_usuario, sum(numero_usuarios) as numero_usuarios, avg(edad_promedio) as avg_edad, AVG(avgtime) AS avg_time, avg(numero_usuarios) as avg_usuarios from mes group by 1',conn)
        print("table not created2!")
        connection_string = "postgresql://postgres:"+passW+"@localhost:5432/newecobici"
        print("table not created3!")
        engine = create_engine(connection_string)
        print("table not created4!")
        df.to_sql(f'dash1_{varYrD1}', con=engine, if_exists="replace", index = False)
        print("table not created5!")
    except:
        print("table created! =)!")
        bbb1=1
        del bbb1

    try:
        df = pd.read_sql_query(f'SELECT * FROM public."dash1_{varYrD1}";',conn)
        print("Read from table!")
    except:
        df = pd.read_sql_query(f'with mes as(select genero_usuario,mes_retiro,count(genero_usuario) as numero_usuarios,avg(edad_usuario) as edad_promedio,AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS avgtime from ecobicidf where anio_retiro in ({varYrD1}) group by 1,2) select genero_usuario, sum(numero_usuarios) as numero_usuarios, avg(edad_promedio) as avg_edad, AVG(avgtime) AS avg_time, avg(numero_usuarios) as avg_usuarios from mes group by 1',conn)
        print("this should never happen!!")
    conn.close()
    json = df.to_json(orient='records',date_format='iso')
    response = Response(response=json, status=200, mimetype="application/json")
    return(response)

@app.route("/api/dash2", methods=["POST"])
def dash2():
    miRequest = request.json
    varDisagg = str(miRequest["valueDisagg"])
    varGtype = str(miRequest["valueGtype"])
    
    plugQueryBegin=""
    plugQueryMid1=""
    plugQueryMid2=""
    plugQueryMid3=""
    plugQueryEnd=""

    if varGtype=="daily":
        plugQueryBegin="SELECT fecha_retiro AS ddate, "
        plugQueryEnd=" FROM ecobicidf GROUP BY(fecha_retiro) ORDER BY(fecha_retiro);"
    elif varGtype=="monthly":
        plugQueryBegin="SELECT TO_CHAR(DATE_TRUNC('month',fecha_retiro)::DATE,'Mon-YYYY') AS ddate, "
        plugQueryEnd=" FROM ecobicidf GROUP BY(DATE_TRUNC('month',fecha_retiro)::date ) ORDER BY (DATE_TRUNC('month',fecha_retiro)::DATE);"
    elif varGtype=="yearly":
        plugQueryBegin="SELECT EXTRACT(YEAR FROM fecha_retiro) as ddate, "
        plugQueryEnd=" FROM ecobicidf GROUP BY EXTRACT(YEAR FROM fecha_retiro);"
    elif varGtype=="dayOfWeek":
        plugQueryBegin="WITH sub AS(SELECT fecha_retiro, "
        plugQueryMid2=" FROM ecobicidf GROUP BY(fecha_retiro)) SELECT TO_CHAR(fecha_retiro,'Dy') AS ddate, "
        plugQueryEnd=" , TO_CHAR(fecha_retiro, 'D') AS junk FROM sub GROUP BY(TO_CHAR(fecha_retiro,'Dy'),TO_CHAR(fecha_retiro,'D')) ORDER BY junk;"
        if varDisagg=="all":
            plugQueryMid3=" AVG(count) AS count "
        elif varDisagg=="gender":
            plugQueryMid3=" AVG(tot_fem) AS tot_fem, AVG(tot_masc) AS tot_masc "
        elif varDisagg=="age":
            plugQueryMid3=" AVG(tot_you) AS tot_you, AVG(tot_mid) AS tot_mid, AVG(tot_old) AS tot_old, AVG(tot_eld) AS tot_eld "
        elif varDisagg=="time":
            plugQueryMid3=" AVG(tot_beg) AS tot_beg, AVG(tot_mor) AS tot_mor, AVG(tot_aft) AS tot_aft, AVG(tot_eve) AS tot_eve "
        elif varDisagg=="length":
            plugQueryMid3=" AVG(tot_zeroten) AS tot_zeroten, AVG(tot_tentwenty) AS tot_tentwenty, AVG(tot_tewntythirty) AS tot_tewntythirty, AVG(tot_thritymore) AS tot_thritymore "
    elif varGtype=="monthOfYear":
        plugQueryBegin="WITH sub AS(SELECT fecha_retiro, "
        plugQueryMid2=" FROM ecobicidf GROUP BY(fecha_retiro)) SELECT TO_CHAR(fecha_retiro,'Mon') AS ddate, "
        plugQueryEnd=" , TO_CHAR(fecha_retiro, 'MM') AS junk FROM sub GROUP BY(TO_CHAR(fecha_retiro,'MM'), TO_CHAR(fecha_retiro,'Mon')) ORDER BY junk;"
        if varDisagg=="all":
            plugQueryMid3=" AVG(count) AS count "
        elif varDisagg=="gender":
            plugQueryMid3=" AVG(tot_fem) AS tot_fem, AVG(tot_masc) AS tot_masc "
        elif varDisagg=="age":
            plugQueryMid3=" AVG(tot_you) AS tot_you, AVG(tot_mid) AS tot_mid, AVG(tot_old) AS tot_old, AVG(tot_eld) AS tot_eld "
        elif varDisagg=="time":
            plugQueryMid3=" AVG(tot_beg) AS tot_beg, AVG(tot_mor) AS tot_mor, AVG(tot_aft) AS tot_aft, AVG(tot_eve) AS tot_eve "
        elif varDisagg=="length":
            plugQueryMid3=" AVG(tot_zeroten) AS tot_zeroten, AVG(tot_tentwenty) AS tot_tentwenty, AVG(tot_tewntythirty) AS tot_tewntythirty, AVG(tot_thritymore) AS tot_thritymore "
            plugQueryBegin="WITH sub AS(SELECT fecha_retiro, "
            plugQueryMid2=" FROM ecobicidf GROUP BY(fecha_retiro)) SELECT EXTRACT(YEAR FROM fecha_retiro) AS ddate, "
            plugQueryEnd=" FROM sub GROUP BY EXTRACT(YEAR FROM fecha_retiro);"
        if varDisagg=="all":
            plugQueryMid3=" AVG(count) AS count "
        elif varDisagg=="gender":
            plugQueryMid3=" AVG(tot_fem) AS tot_fem, AVG(tot_masc) AS tot_masc "
        elif varDisagg=="age":
            plugQueryMid3=" AVG(tot_you) AS tot_you, AVG(tot_mid) AS tot_mid, AVG(tot_old) AS tot_old, AVG(tot_eld) AS tot_eld "
        elif varDisagg=="time":
            plugQueryMid3=" AVG(tot_beg) AS tot_beg, AVG(tot_mor) AS tot_mor, AVG(tot_aft) AS tot_aft, AVG(tot_eve) AS tot_eve "
        elif varDisagg=="length":
            plugQueryMid3=" AVG(tot_zeroten) AS tot_zeroten, AVG(tot_tentwenty) AS tot_tentwenty, AVG(tot_tewntythirty) AS tot_tewntythirty, AVG(tot_thritymore) AS tot_thritymore "

    if varDisagg=="all":
        plugQueryMid1=" COUNT(*) "
    elif varDisagg=="gender":
        plugQueryMid1=" SUM(CASE WHEN genero_usuario = 'F' THEN 1 ELSE 0 END) AS tot_fem, SUM(CASE WHEN genero_usuario = 'M' THEN 1 ELSE 0 END) AS tot_masc "
    elif varDisagg=="age":
        plugQueryMid1=" SUM(CASE WHEN edad_usuario BETWEEN 0 AND 25 THEN 1 ELSE 0 END) AS tot_you, SUM(CASE WHEN edad_usuario BETWEEN 26 AND 35 THEN 1 ELSE 0 END) AS tot_mid, SUM(CASE WHEN edad_usuario BETWEEN 36 AND 45 THEN 1 ELSE 0 END) AS tot_old, SUM(CASE WHEN edad_usuario>=46 THEN 1 ELSE 0 END) AS tot_eld "
    elif varDisagg=="time":
        plugQueryMid1=" SUM(CASE WHEN (hora_retiro>='00:00:00' AND hora_retiro<'06:00:00') THEN 1 ELSE 0 END) AS tot_beg, SUM(CASE WHEN (hora_retiro>='06:00:00' AND hora_retiro<'12:00:00') THEN 1 ELSE 0 END) AS tot_mor, SUM(CASE WHEN (hora_retiro>='12:00:00' AND hora_retiro<'18:00:00') THEN 1 ELSE 0 END) AS tot_aft, SUM(CASE WHEN (hora_retiro>='18:00:00') THEN 1 ELSE 0 END) AS tot_eve "
    elif varDisagg=="length":
        plugQueryMid1=" SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:00:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:10:00' THEN 1 ELSE 0 END) AS tot_zeroten, SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:10:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:20:00' THEN 1 ELSE 0 END) AS tot_tentwenty, SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:20:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:30:00' THEN 1 ELSE 0 END) AS tot_tewntythirty, SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:30:00' THEN 1 ELSE 0 END) AS tot_thritymore "

    plugQuery=plugQueryBegin+plugQueryMid1+plugQueryMid2+plugQueryMid3+plugQueryEnd

    conn = psycopg2.connect(database="newecobici",user="postgres", password=passW, host ="localhost",port="5432")
    df = pd.read_sql_query(plugQuery,conn)
    conn.close()
    json = df.to_json(orient='records',date_format='iso')
    response = Response(response=json, status=200, mimetype="application/json")
    return(response)

@app.route("/api/dash3", methods=["POST"])
def dash3():
    miRequest = request.json
    varDisagg = str(miRequest["valueDisagg"])

    plugQueryBegin="SELECT ciclo_estacion_retiro AS station_begin, ciclo_estacion_arribo AS station_end, "
    plugQueryEnd="AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS triptime FROM ecobicidf WHERE(ciclo_estacion_retiro<>ciclo_estacion_arribo) GROUP BY 1,2 ORDER BY tot DESC LIMIT 10;"
    if varDisagg=="all":
        plugQueryMid="COUNT(*) AS tot, "
    elif varDisagg=="genderfemale":
        plugQueryMid="SUM(CASE WHEN genero_usuario = 'F' THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="gendermale":
        plugQueryMid="SUM(CASE WHEN genero_usuario = 'M' THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="timebeg":
	    plugQueryMid="SUM(CASE WHEN (hora_retiro>='00:00:00' AND hora_retiro<'06:00:00') THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="timemor":
	    plugQueryMid="SUM(CASE WHEN (hora_retiro>='06:00:00' AND hora_retiro<'12:00:00') THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="timeaft":
	    plugQueryMid="SUM(CASE WHEN (hora_retiro>='12:00:00' AND hora_retiro<'18:00:00') THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="timeeve":
	    plugQueryMid="SUM(CASE WHEN (hora_retiro>='18:00:00') THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="length010":
	    plugQueryMid="SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:00:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:10:00' THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="length1020":
	    plugQueryMid="SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:10:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:20:00' THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="length2030":
	    plugQueryMid="SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:20:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:30:00' THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="length30more":
	    plugQueryMid="SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:30:00' THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="age025":
	    plugQueryMid="SUM(CASE WHEN edad_usuario BETWEEN 0 AND 25 THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="age2635":
	    plugQueryMid="SUM(CASE WHEN edad_usuario BETWEEN 26 AND 35 THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="age3645":
	    plugQueryMid="SUM(CASE WHEN edad_usuario BETWEEN 36 AND 45 THEN 1 ELSE 0 END) AS tot, "
    elif varDisagg=="age46more":
	    plugQueryMid="SUM(CASE WHEN edad_usuario>=46 THEN 1 ELSE 0 END) AS tot, "

    plugQuery=plugQueryBegin+plugQueryMid+plugQueryEnd

    conn = psycopg2.connect(database="newecobici",user="postgres", password=passW, host ="localhost",port="5432")
    df = pd.read_sql_query(plugQuery,conn)
    conn.close()
    json = df.to_json(orient='records',date_format='iso')
    response = Response(response=json, status=200, mimetype="application/json")
    return(response)

@app.route("/api/dash4", methods=["POST"])
def dash4():
    miRequest = request.json
    print(miRequest)
    varstart = str(miRequest["varstart"])
    varend = str(miRequest["varend"])
    vargender = str(miRequest["vargender"])

    model = load_model("bikeflux_model.h5")

    times=[[0,3599],
    [3600,7199],
    [7200,10799],
    [10800,14399],
    [14400,17999],
    [18000,21599],
    [21600,25199],
    [25200,28799],
    [28800,32399],
    [32400,35999],
    [36000,39599],
    [39600,43199],
    [43200,46799],
    [46800,50399],
    [50400,53999],
    [54000,57599],
    [57600,61199],
    [61200,64799],
    [64800,68399],
    [68400,71999],
    [72000,75599],
    [75600,79199],
    [79200,82799],
    [82800,86399]]


    sel_xi=int(varstart)
    sel_xf=int(varend)
    if vargender=="both":
        sel_y=['M','F']
    elif vargender=="male":
        sel_y=['M']
    elif vargender=="female":
        sel_y=['F']
    maxiter=2

    for x in range(sel_xi,sel_xf):
        xx=x-5
        for y in sel_y:
            for t in range(0,maxiter):
                #print(t)
                smpl=np.random.randint(pd.read_csv('TripsByCombination.csv')['1'][xx], pd.read_csv('TripsByCombination.csv')['0'][xx])
                #print(smpl)
                #print(f'ForFore_{x}_{y}.csv')
                conn = psycopg2.connect(database="newecobici",user="postgres", password='lfsb1101', host ="localhost",port="5432")
                connection_string = "postgresql://postgres:"+'lfsb1101'+"@localhost:5432/newecobici"
                engine = create_engine(connection_string)
                test=pd.read_sql_query(f'SELECT * FROM public."ForFore_{x}_{y}";',conn).sample(replace=False,n=smpl)
                conn.close()
                test=test.merge(pd.read_csv('MaleFemale.csv'),on='genero_usuario',how='left').merge(pd.read_csv('CicloInicio.csv'),on='ciclo_estacion_retiro',how='left')
                test=test[[col for col in test.columns if col!="ciclo_estacion_retiro"]]
                test=test[[col for col in test.columns if col!="genero_usuario"]]
                X_scaler = MinMaxScaler()
                test=X_scaler.fit_transform(test)
                test
                y_predict = model.predict_classes(test)
                aaaa=pd.DataFrame(y_predict)
                aaaa['Total']=1
                for r in range(0,y_predict.shape[0]):
                    if r==0:
                        globals()['y_proba_'+str(x)+'_'+y+'_'+str(t)]=aaaa.groupby([0]).sum().merge(pd.read_csv('yEstaciones.csv'),how='right',left_index=True,right_on='estacionCoded').fillna(0).sort_values(by='estacionOrig')[['Total']].to_numpy()
                    else:
                        globals()['y_proba_'+str(x)+'_'+y+'_'+str(t)]=globals()['y_proba_'+str(x)+'_'+y+'_'+str(t)]+aaaa.groupby([0]).sum().merge(pd.read_csv('yEstaciones.csv'),how='right',left_index=True,right_on='estacionCoded').fillna(0).sort_values(by='estacionOrig')[['Total']].to_numpy()

                if t==0:
                    globals()['trips_'+str(x)+'_'+y]=globals()['y_proba_'+str(x)+'_'+y+'_'+str(t)]
                elif t==maxiter-1:
                    globals()['trips_'+str(x)+'_'+y]=(globals()['trips_'+str(x)+'_'+y]+globals()['y_proba_'+str(x)+'_'+y+'_'+str(t)])/(t+1)
                else:
                    globals()['trips_'+str(x)+'_'+y]=globals()['trips_'+str(x)+'_'+y]+globals()['y_proba_'+str(x)+'_'+y+'_'+str(t)]

    cou=0                
    for x in range(sel_xi,sel_xf):
        xx=x-5
        for y in sel_y:
            if cou==0:
                TotTrips=globals()['trips_'+str(x)+'_'+y]
            else:
                TotTrips=TotTrips+globals()['trips_'+str(x)+'_'+y]
            cou+=1
            
    df=pd.DataFrame(TotTrips).merge(pd.read_csv('yEstaciones.csv'),left_index=True,right_on='estacionCoded').sort_values(by=0,ascending=False).iloc[:10,:][[0,'estacionOrig']]
    json = df.to_json(orient='records',date_format='iso')
    response = Response(response=json, status=200, mimetype="application/json")
    return(response)


    
if __name__=="__main__":
    app.run()
