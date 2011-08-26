/**
 * @author Sean Brown
 */
$(document).ready(function (){ 

	var cGauge;
  	var newVal = parseInt($('#cmeter').val()); 
// 	alert(newVal);
			
	// Draw gauge and use custom bands
	cGauge = new Gauge( document.getElementById( 'credit-gauge' ),
				{
					value: 10000,
					min: 0,
					max: 10000,
					majorTicks: 6,
					minorTicks: 2,
					label: "Credits",
					bands: [
						{ color: '#FF0000', from: 0, to: 2000 },
						{ color: '#F08103', from: 2000, to: 4000 },
						{ color: '#FFFF00', from: 4000, to: 6000 },
						{ color: '#0C6FCB', from: 6000, to: 8000 },
						{ color: '#00FF00', from: 8000, to: 10000 }
					]
				});
			
	cGauge.setValue( newVal );

 });