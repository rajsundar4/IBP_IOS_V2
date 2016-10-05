//line chart
	var data = [ { x_key: 0, y_value: 5 },{ x_key: 1, y_value: 10 },{ x_key: 2, y_value: 13 },{ x_key: 3, y_value: 19 },{ x_key: 4, y_value: 21 },{ x_key: 5, y_value: 25 },{ x_key: 6, y_value: 22 },{ x_key: 7, y_value: 18 },{ x_key: 8, y_value: 15 },{ x_key: 9, y_value: 13 },{ x_key: 10, y_value: 11 },{ x_key: 11, y_value: 12 },{ x_key: 12, y_value: 15 },{ x_key: 13, y_value: 20 },{ x_key: 14, y_value: 18 },{ x_key: 15, y_value: 17 },{ x_key: 16, y_value: 16 },{ x_key: 17, y_value: 18 },{ x_key: 18, y_value: 23 },{ x_key: 19, y_value: 25 } ];

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
	var svg = d3.select("body").append("svg")
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