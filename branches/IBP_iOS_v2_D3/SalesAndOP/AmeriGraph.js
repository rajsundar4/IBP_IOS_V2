//LINE GRAPH

var DATAG_MOD = (function(){
                 var labels = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"];
                 
                 return {
                 newDataSet : function() {
                 var labelSet = labels,
                 dataSet = [];
                 
                 for (var i = 0; i < labelSet.length; i++) {
                 var entry = { "label" : labelSet[i], "value" : Math.floor(Math.random() * 100) };
                 dataSet.push(entry);
                 }
                 
                 return dataSet;
                 }
                 };
                 });

// verticle Bar chart

function verticleBarChart(chart, presets) {
    var svg, data, x0, x1, y, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
    width, height, XAxisKey, keys, datasets;
    
    //get the DOM Factors(width & Height) where this chart will be rendered
    var BBox = d3.select("#" + chart).node().getBoundingClientRect();
    
    var h = .45 * BBox.width; //Calculated height for window based on width fetched from "BBox"
    
    //configs of the svg to be rendered
    margin = {
    top: 20,
    right: 0.18 * BBox.width,
    bottom: 40,
    left: 40
    }
    width = BBox.width - margin.left - margin.right,
    height = h - margin.top - margin.bottom;
    
    //setting the user defined colorPallete
    var colors = d3.scale.ordinal()
    .range(presets.plotArea.colorPalette);
    
    data = presets.dataset;
    //get the keys of enitre data
    keys = d3.keys(data[0]);
    
    //fetch the XCordinate dynamically or given in presets
    var XAxisKeyraw = presets.dimensions[0].value;
    XAxisKey = XAxisKeyraw.replace(/[{}]/g, '');
    
    //fetch the y axis keys apart from x-axis
    datasets = d3.keys(data[0]).filter(function(key) {
                                       return key !== XAxisKey;
                                       });
    
    //mapping (grouping) the data as required to render
    data.forEach(function(d) {
                 d.values = datasets.map(function(name) {
                                         return {
                                         key: d["" + XAxisKey + ""],
                                         name: name,
                                         value: +Number(d[name])
                                         };
                                         });
                 });
    
    //initialize scales
    xExtent = data.map(function(d) {
                       return d["" + XAxisKey + ""];
                       });
    
    //legend data manipulation
    var legendSet = presets.measures;
    //overWrite with un-braced data values
    legendSet = legendSet.map(function(l) {
                              return {
                              name: l.name,
                              key: l.value.replace(/[{}]/g, '')
                              }
                              })
    
    //scaling axis
    x0 = d3.scale.ordinal().rangeRoundBands([10, width], 0.3).domain(xExtent); //Actual x-Axis Scale
    x1 = d3.scale.ordinal().domain(datasets).rangeRoundBands([10, x0.rangeBand()], 0.1); //Series Scaling on X-Axis
    y = d3.scale.linear().domain([0, d3.max(data, function(d) {
                                            return d3.max(d.values, function(d) {
                                                          return d.value;
                                                          });
                                            })]).range([height, 20]); //y-Axis Scale
    
    //initialize axis and formatting
    xAxis = d3.svg.axis().orient('bottom');
    yAxis = d3.svg.axis().orient('left');
    var yFormat = d3.format('.1s');
    
    //initialize svg
    svg = d3.select("#" + chart).append('svg')
    .attr("width", BBox.width)
    .attr("height", h)
    // .attr("preserveAspectRatio", "xMinYMin slice")
    // .attr("viewBox", "0 0 480 307")
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    
    chartWrapper = svg.append('g').attr("class", "chartWrapper");
    chartWrapper.append('g').classed('x axis', true)
    chartWrapper.append('g').classed('y axis', true);
    
    //Axis Ticks
    xAxis.scale(x0).tickSize(2);
    yAxis.scale(y).tickSize(1).tickFormat(yFormat).ticks(6);
    
    //Append x-Axis to svg
    svg.select('.x.axis')
    .attr('transform', 'translate(0,' + (height) + ')')
    .call(xAxis);
    
    //Append y-Axis to svg
    svg.select('.y.axis')
    .attr('transform', 'translate(' + (margin.left / 2) + ',' + 0 + ')')
    .call(yAxis);
    
    //draw y lines inside the chart
    svg.selectAll(".y >.tick > line")
    .attr("x2", width - margin.left);
    
    //create groups for each series
    var set = svg.select("g.chartWrapper").selectAll(".dataset")
    .data(data)
    .enter().append("g")
    .attr("class", "dataset")
    .attr("transform", function(d, i) {
          return "translate(" + (x0(d["" + XAxisKey + ""])) + "," + 0 + ")";
          })
    
    //create rect and render y-values.
    set.selectAll(".rect")
    .data(function(d, i) {
          return d.values
          })
    .enter()
    .append("rect")
    .attr("width", x1.rangeBand())
    .attr("x", function(d) {
          return x1(d.name);
          })
    .attr("y", function(d) {
          var value = y(d.value);
          if (isNaN(value)) {
          return 0;
          } else {
          return value;
          }
          })
    .attr("height", function(d) {
          var value = y(d.value);
          if (isNaN(value)) {
          return 0;
          } else {
          return height - value;
          }
          })
    .style("fill", function(d) {
           return colors(d.name);
           })
    .attr("data-legend", function(d) {
          var attr;
          legendSet.forEach(function(l) {
                            if (l.key === d.name) {
                            attr = l.name
                            }
                            });
          return attr;
          })
    
    
    //create a lengend element of <g> and append to svg
    legend = svg.append("g")
    .attr("class", "legend")
    .attr('transform', 'translate(5,50)');
    
    //draw legend factors fetching data from the given elements
    legend.selectAll('rect')
    .data(legendSet)
    .enter()
    .append("g")
    .attr("width", "100")
    .attr("height", "50").attr('transform', 'translate(0,0)')
    .attr("class", "legend-item")
    .append("rect")
    .attr("x", width)
    .attr("y", function(d, i) {
          return i * 15;
          })
    .attr("width", 10)
    .attr("height", 10)
    .style("fill", function(d, i) {
           return colors(d.key)
           })
    legend.selectAll('.legend-item')
    .append("text")
    .attr('x', width + 12)
    .attr('y', function(d, i) {
          return i * 15 + 9;
          })
    .text(function(d, i) {
          return d.name
          });
}

function chart(data, chart, AxisLabels){
    var svg, data, x0, x1, y, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
    width, height, XAxisKey, keys, datasets;
    
    var BBox = d3.select("#"+chart).node().getBoundingClientRect();
    // console.log(BBox);
    var h = .45*BBox.width;
    margin = {top: 20, right: 150, bottom: 50, left: 50}
    width = (BBox.width+80) - margin.left - margin.right,
    height = h - margin.top - margin.bottom;
    // console.log(BBox.width,.6*BBox.width);
    
    var colors = d3.scale.ordinal()
    .range(["#377EB8", "#4DAF4A", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);
    
    keys = d3.keys(data[0]);
    XAxisKey = keys[keys.length - 1];
    
    datasets = d3.keys(data[0]).filter(function(key) {
                                       return key !== XAxisKey;
                                       });
    
    data.forEach(function(d) {
                 d.sets = datasets.map(function(name) {
                                       return {
                                       key: d["" + XAxisKey + ""],
                                       name: name,
                                       value: +Number(d[name])
                                       };
                                       });
                 });
    
    
    //initialize scales
    xExtent = data.map(function(d) {
                       return d["" + XAxisKey + ""];
                       });
    
    x0 = d3.scale.ordinal().rangeRoundBands([10, width], 0.01).domain(xExtent);
    x1 = d3.scale.ordinal().domain(datasets).rangeRoundBands([10, x0.rangeBand()], 0.05);
    y = d3.scale.linear().domain([0, d3.max(data, function(d) {
                                            return d3.max(d.sets, function(d) {
                                                          return d.value;
                                                          });
                                            })]).range([height, 20]);
    
    //initialize axis
    xAxis = d3.svg.axis().orient('bottom');
    yAxis = d3.svg.axis().orient('left');
    var yFormat = d3.format('.1s');
    
    //initialize svg
    svg = d3.select("#"+chart).append('svg')
    .attr("width", BBox.width)
    .attr("height", h)
     //.attr("preserveAspectRatio", "xMinYMin meet")
    //.attr("viewBox", "0 0 50 30")
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    
    chartWrapper = svg.append('g').attr("class", "chartWrapper");
    chartWrapper.append('g').classed('x axis', true)
    chartWrapper.append('g').classed('y axis', true);
    
    // Define the div for the tooltip
    var div = d3.select("#"+chart).append("div")
    .attr("class", "tooltip")
    .style("opacity", 0);
    
    xAxis.scale(x0).tickSize(2);
    
    yAxis.scale(y).tickSize(0).tickFormat(yFormat);
    
    
    svg.select('.x.axis')
    .attr('transform', 'translate(0,' + (height) + ')')
    .call(xAxis);
    
    svg.select('.x.axis').append("text")
    .attr("text-anchor", "middle") // this makes it easy to centre the text as the transform is applied to the anchor
    .attr("transform", "translate(" + (width / 2) + "," + (margin.bottom-5) + ")") // text is drawn off the screen top left, move down and out and rotate
    .text(AxisLabels.x);
    
    svg.select('.y.axis')
    .attr('transform', 'translate(' + (margin.left / 2) + ',' + 0 + ')')
    .call(yAxis);
    
    svg.selectAll(".y >.tick > line")
    .attr("x2", width - margin.left);
    
    svg.select('.y.axis').append("text")
    .attr("text-anchor", "middle") // this makes it easy to centre the text as the transform is applied to the anchor
    .attr("transform", "translate(" + -(margin.left) + "," + (height / 2) + ")rotate(-90)") // text is drawn off the screen top left, move down and out and rotate
    .text(AxisLabels.y);
    
    svg.select(".chartWrapper").append("line")
    .attr("x1", width-20) //<<== change your code here
    .attr("y1", margin.top)
    .attr("x2", width-20) //<<== and here
    .attr("y2", height)
    .attr("class", "border-line");
    
    var set = svg.select("g.chartWrapper").selectAll(".dataset")
    .data(data)
    .enter().append("g")
    .attr("class", "dataset")
    .attr("transform", function(d, i) {
          return "translate(" + (x0(d["" + XAxisKey + ""])) + "," + 0 + ")";
          })
    .on("mouseover", function(d) {
        // d3.select(this)
        //     .classed("active", true );
        // should then accept fill from CSS
        d3.select(this)
        .selectAll(function(d) {
                   var sets = d.sets;
                   var tip = "<div><ul>" +d["" + XAxisKey + ""]+"";
                   for(var i=0; i< sets.length; i++)
                   {
                   var value = sets[i].value
                   if(isNaN(value)){
                   tip+= "<li>" +sets[i].name+","+ 0 +"</li>";
                   }
                   tip += "<li>" +sets[i].name+","+value+"</li>";
                   
                   }
                   tip += "</ul></li>"
                   div.transition()
                   .duration(200)
                   .style("opacity", .9);
                   div.html(tip)
                   .style("left", (d3.event.pageX) + "px")
                   .style("top", (d3.event.pageY - 28) + "px");
                   
                   })
        
        })
    .on("mouseout", function(d) {
        // d3.select(this)
        //     .classed("active", false ) ;
        // should then accept fill from CSS
        d3.select(this)
        .each(function(d){
              div.transition()
              .duration(500)
              .style("opacity", 0);
              });
        });
    
    set.selectAll(".rect")
    .data(function(d,i) {
          return d.sets
          })
    .enter()
    .append("rect")
    .attr("width", x1.rangeBand() / 2)
    .attr("x", function(d) {
          return x1(d.name);
          })
    .attr("y", function(d) {
          var value = y(d.value);
          if(isNaN(value)){
          return 0;
          }
          else {
          return value;
          }
          })
    .attr("height", function(d) {
          var value = y(d.value);
          if(isNaN(value)){
          return 0;
          }
          else {
          return height-value;
          }
          })
    .style("fill", function(d) {
           return colors(d.name);
           })
    .attr("data-legend",function(d) { return d.name})
    
    
    
    legend = svg.append("g")
		  .attr("class","legend")
		  .attr('transform', 'translate(-15,50)');
    
    legend.selectAll('rect')
    .data(datasets)
    .enter()
    .append("g")
    .attr("width", "100")
    .attr("height", "50").attr('transform', 'translate(0,0)')
    .attr("class", "legend-item")
    .append("rect")
    .attr("x", width )
    .attr("y", function(d, i){ return i *  15;})
    .attr("width", 10)
    .attr("height", 10)
    .style("fill", function(d,i) {
           return colors(d)
           })
    legend.selectAll('.legend-item')
    .append("text")
    .attr('x', width + 12)
    .attr('y', function(d, i){ return i *  15 + 9;})
    .text(function(d,i){ return d});
}

// Line Graph
function lineGraph(data,eid)
{
	var margin = {top: 20, right: 30, bottom: 30, left: 70},
		width = 960 - margin.left - margin.right,
		height = 500 - margin.top - margin.bottom;

	var x = d3.scale.linear()
			.domain([0, d3.max(data,function(d){return d.x_key;})])
			.range([0, width]);
	
	var y = d3.scale.linear()
			.domain([0, d3.max(data,function(d){return d.y_value;})])
			.range([height, 0]);
			
	//create axis
	var xAxis = d3.svg.axis()
				.scale(x)
				.orient("bottom");
	
	var yAxis= d3.svg.axis()
				.scale(y)
				.orient("left");
	
	// Define the div for the tooltip
	var div = d3.select("body").append("div")	
    .attr("class", "tooltip")//css class				
    .style("opacity", 0);

	//svg object
	var svg = d3.select(eid).append("svg")
			.attr("width", width + margin.left + margin.right)
			.attr("height", height + margin.top + margin.bottom)
			.append("g")
			.attr("transform", "translate(" + margin.left + "," + margin.top + ")");
			
	
	// Add the axis					
	svg.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(0," + height + ")")
		.call(xAxis);
				  
	svg.append("g")
		.attr("class", "y axis")
		.call(yAxis);
	
	//name axis		
	svg.append("g")
	.attr("class", "x axis")
	.append("text")
	.attr("class", "axis-label")
    .attr("transform", "translate(" + ((width / 2)-10) + " ," + (height + margin.bottom) + ")")
    .text("x-axis");
	
	svg.append("g")
	.attr("class", "y axis")
	.append("text")
	.attr("class", "axis-label")
	.attr("transform", "rotate(-90)")
	.attr("y", (-margin.left) + 10)
	.attr("x", -height/2)
	.text('y-axis');
	
	// line function to convert data to x,y points
	var line = d3.svg.line()
	.interpolate("linear") //linear-for sharp curves;basis-for smooth curves
	  .x(function(d) {
		return x(d.x_key);
	  })
	  .y(function(d) {
		return y(d.y_value);
	  });
		
	svg.append('path')
	  .attr('d', line(data))
	  .attr('stroke', 'green')
	  .attr('fill', 'none');
	  
	//dots
	svg.selectAll("dot")
        .data(data)
		.enter().append("circle")
		.attr('fill', 'green')
        .attr("r", 3)
        .attr("cx", function(d) { return x(d.x_key); })
        .attr("cy", function(d) { return y(d.y_value); })
		
		//for tooltip
		.on("mouseover", function(d) {		
            div.transition()		
                .duration(200)		
                .style("opacity", .9);		
            div	.html(d.x_key + "," + d.y_value)	
                .style("left", (d3.event.pageX) + "px")		
                .style("top", (d3.event.pageY - 28) + "px");	
            })					
        .on("mouseout", function(d) {		
            div.transition()		
                .duration(500)		
                .style("opacity", 0);	
        });
}

//MULTI-LINE GRAPH
function multilineGraph(data,eid)
{
	var colors = [
		'steelblue',
		'green',
		'red',
		'purple',
		'yellow'
	]
	 
	// Create Margins and Axis
var margin = {top: 20, right: 30, bottom: 30, left: 70},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;
	
var x = d3.time.scale()
  .domain([new Date(2015, 5, 1),new Date(2016, 1, 31)])
   .range([0, width]);
 
var y = d3.scale.linear()
    .domain([-30.000000, 26000.000000])
    .range([height, 0]);
	
//create axis	
var xAxis = d3.svg.axis()
    .scale(x)
	.tickPadding(10)		
    .orient("bottom")
	.tickSize(10,1)
	.tickFormat(d3.time.format("%b,%Y"));	// format to change x-axis y_values
	
var yAxis = d3.svg.axis()
    .scale(y)
	.tickPadding(10)
    .orient("left");

 // Define the div for the tooltip
var div = d3.select("body").append("div")	
    .attr("class", "tooltip")				
    .style("opacity", 0);
	
// Generate our SVG object

var svg = d3.select(eid).append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
	.append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
//axis
svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

svg.append("g")
    .attr("class", "y axis")
    .call(yAxis);	
	
//name axis 
svg.append("g")
	.attr("class", "x axis")
	.append("text")
	.attr("class", "axis-label")
    .attr("transform", "translate(" + ((width / 2)-10) + " ," + (height + margin.bottom) + ")")
    .text("x-axis");
 
svg.append("g")
	.attr("class", "y axis")
	.append("text")
	.attr("class", "axis-label")
	.attr("transform", "rotate(-90)")
	.attr("y", (-margin.left) + 10)
	.attr("x", -height/2)
	.text('y-axis');	

// to truncate the extra lines 	
svg.append("clipPath")
	.attr("id", "clip")
	.append("rect")
	.attr("width", width)
	.attr("height", height);
	

// Create D3 line object and draw data on our SVG object

var line = d3.svg.line()
    .x(function(d) { 
        return x(getDate(d)); 
    })
    .y(function(d) { 
        return y(d.y_value); 
    });
	
svg.selectAll('.line')
	.data(data)
	.enter()
	.append("path")
    .attr("class", "line")
	.attr("clip-path", "url(#clip)")
	.attr('stroke', function(d,i){ 			
		return colors[i%colors.length];
	})
    .attr("d", line);		
//date format for tooltip
var formatDate = d3.time.format("%b,%Y");

// Draw points on SVG object based on the data given

var points = svg.selectAll('.dots')
	.data(data)
	.enter()
	.append("g")
    .attr("class", "dots")
	.attr("clip-path", "url(#clip)");
	
	points.selectAll('.dot')
	.data(function(d, index){ 		
		var a = [];
		d.forEach(function(point,i){
			a.push({'index': index, 'point': point});
		});		
		return a;
	})
	.enter()
	.append('circle')
	.attr('class','dot')
	.attr("r", 3.5)
	.attr('fill', function(d,i){ 	
		return colors[d.index%colors.length];
	})	
	.attr("transform", function(d) { 
		return "translate(" + x(getDate(d.point)) + "," + y(d.point.y_value) + ")"; }
	)
	//tooltip
	.on("mouseover", function(d) {		
            div.transition()		
                .duration(200)		
                .style("opacity", .9);		
            div	.html(formatDate(getDate(d.point)) + "<br>" + d.point.y_value)	
                .style("left", (d3.event.pageX) + "px")		
                .style("top", (d3.event.pageY - 28) + "px");	
            })					
        .on("mouseout", function(d) {		
            div.transition()		
                .duration(500)		
                .style("opacity", 0);	
        });
}
	//to format the date in %d/%m/%Y format	
	 function getDate(d) {
		 var parseDate = d3.time.format("%d/%m/%Y").parse;
		return parseDate(d.x_key);
	}

//PIE CHART
function pieChart(data,eid)
{
	//margins
	var w = 400;
	var h = 400;
	var r = h/2;
	var color = d3.scale.category20();//color codes(defined in d3 categorical colors)
	
 // Define the div for the tooltip
var div = d3.select("body").append("div")	
    .attr("class", "tooltip")				
    .style("opacity", 0);
	
// Generate our SVG object
	var svg = d3.select(eid)
			.append("svg")
			.data([data])
			.attr("width", w)
			.attr("height", h)
			.append("g")
			.attr("transform", "translate(" + r + "," + r + ")");
			
	var pie = d3.layout.pie()
				.value(function(d){return d.y_value;});

	// declare an arc generator function
	var arc = d3.svg.arc()
					.outerRadius(r);

	// select paths, use arc generator to draw
	var arcs = svg.selectAll(".slice")
				  .data(pie)
				  .enter()
				  .append("g").attr("class", "slice");
				  
				  
	arcs.append("path")
		.attr("fill", function(d, i){
			return color(i);
		})
		.attr("d", function (d) {
			return arc(d);
		})
		.on("mouseover", function(d) {		
            div.transition()		
                .duration(200)		
                .style("opacity", .9);		
            div	.html(d.data.x_key + "," + d.data.y_value)	
                .style("left", (d3.event.pageX) + "px")		
                .style("top", (d3.event.pageY - 28) + "px");	
            })					
        .on("mouseout", function(d) {		
            div.transition()		
                .duration(500)		
                .style("opacity", 0);	
        });

	// add the text
	arcs.append("text").attr("transform", function(d){
				d.innerRadius = 50;
				d.outerRadius = r;
		return "translate(" + arc.centroid(d) + ")";})		
		.attr("text-anchor", "middle")
		.text( function(d, i) {
				return data[i].x_key+" - "+data[i].y_value+"%";}
			);
}

//BAR GRAPH
function barGraph(data,eid)
{
	// Create Margins and Axis
	var margin = {top: 20, right: 30, bottom: 30, left: 70},
		w = 960 - margin.left - margin.right,
		h= 500 - margin.top - margin.bottom;


	var x = d3.scale.ordinal()
					.domain(d3.range(data.length))
					.rangeRoundBands([0, w]); 

	var y = d3.scale.linear()
					.domain([0, d3.max(data, function(d) {return d.y_value;})])
					.range([h, 0]);
					
	var xAxis = d3.svg.axis()
					.scale(x)		
					.orient("bottom");

	var yAxis = d3.svg.axis()
		.scale(y)
		.orient("left");
		
	var x_key = function(d) {
		return d.x_key;
	};
	


	// Generate our SVG object
	var svg = d3.select(eid)
				.append("svg")
				.attr("width", w + margin.left + margin.right)
				.attr("height",h + margin.top + margin.bottom)
				   .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	svg.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(0," + h + ")")
		.call(xAxis);

	svg.append("g")
		.attr("class", "y axis")
		.call(yAxis);

	
	// Define the div for the tooltip
	var div = d3.select("body").append("div")	
    .attr("class", "tooltip")//css class				
    .style("opacity", 0);
	
	//Create bars
	svg.selectAll("rect")
	   .data(data, x_key)
	   .enter()
	   .append("rect")
	   .attr("x", function(d, i) {
			return x(i);
	   })
	   .attr("y", function(d) {
			return y(d.y_value);
	   })
	   .attr("width", x.rangeBand())
	   .attr("height", function(d) {
			return h-y(d.y_value);
	   })
	   
	   //color the rectangular bars
	   .attr("fill", function(d) {
			return "rgb(0, " + (d.y_value * 5) + ", " + (d.y_value * 7) + ")";
	   })
	   
	    //tooltip
	   .on("mouseover", function(d) {		
            div.transition()		
                .duration(200)		
                .style("opacity", .9);		
            div	.html(d.x_key + "," + d.y_value)	
                .style("left", (d3.event.pageX) + "px")		
                .style("top", (d3.event.pageY - 28) + "px");	
            })					
        .on("mouseout", function(d) {		
            div.transition()		
                .duration(500)		
                .style("opacity", 0);	
        });
		

	//Create labels
	svg.selectAll("text")
	   .data(data, x_key)
	   .enter()
	   .append("text")
	   .text(function(d) {
			return d.y_value;
	   })
	   .attr("text-anchor", "middle")
	   .attr("x", function(d, i) {
			return x(i) + x.rangeBand() / 2;
	   })
	   .attr("y", function(d) {
			return y(d.y_value) + 14;
	   })
	   .attr("class","label");
	   
	  //name axis	
	svg.append("g")
	.attr("class", "x axis")
	.append("text")
	.attr("class", "axis-label")
    .attr("transform", "translate(" + ((w / 2)-10) + " ," + (h + margin.bottom) + ")")
    .text("x-axis");
	
	svg.append("g")
	.attr("class", "y axis")
	.append("text")
	.attr("class", "axis-label")
	.attr("transform", "rotate(-90)")
	.attr("y", (-margin.left) + 10)
	.attr("x", -h/2)
	.text('y-axis');
}
