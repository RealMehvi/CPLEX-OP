/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Meh
 * Creation Date: Apr 14, 2024 at 2:41:24 AM
 *********************************************/



int npoint = ...;

range rnode = 1..npoint;



float xc[rnode] = ...;
float yc[rnode] = ...;
int ss[rnode] = ...;


int time = ...;


float dist[rnode][rnode];

execute{
	function getDistance(i,j){
	  	return Opl.sqrt(Opl.pow((xc[i]-xc[j]),2) + Opl.pow((yc[i]-yc[j]),2));  
	}
	for (var i in rnode){
	  for(var j in rnode){
	    dist[i][j] = getDistance(i,j);
	  }
	}
}



dvar boolean x[rnode][rnode];
dvar float+ u[2..npoint];

dexpr float obj = sum (i in 2..npoint-1, j in 2..npoint) ss[i]*x[i][j];
maximize obj;


subject to{
  	    const1: sum(j in 2..npoint)     x[1][j] == 1;
		const2: sum(i in 1..npoint-1)  x[i][npoint] == 1;
		

		forall(k in 2..npoint-1){
         const3:    sum(i in 1..npoint-1) x[i][k] <= 1;
		 const4: sum(i in 1..npoint-1)x[i][k] == sum(j in 2..npoint: j!=k)x[k][j];
			}
						
		  const5:
		  	sum(i in 1..npoint-1,j in 2..npoint)dist[i][j]*x[i][j] <= time;
	
	  	    
	  	 forall(i in 2..npoint, j in 2..npoint: i!=j) {
         	SE0:u[i]-u[j]+1 <= (npoint-1)*(1-x[i][j]);
         	}
         forall (i in 2..npoint){
           u[i]>= 2;
           u[i]<= npoint;
         }
         
         
}