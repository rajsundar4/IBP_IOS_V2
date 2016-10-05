function heatmap(chart, presets) {
    var svg, data, x, y, z, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
    width, height, XAxisKey, keys, datasets = [], arr = [];

    //get the DOM Factors(width & Height) where this chart will be rendered
    var BBox = d3.select("#" + chart).node().getBoundingClientRect();

    var h = .45 * BBox.width; //Calculated height for window based on width fetched from "BBox"

    //configs of the svg to be rendered
    margin = {
        top: 40,
        right: 0.18 * BBox.width,
        bottom: 40,
        left: 50
    }
    width = BBox.width - margin.left - margin.right,
    height = h - margin.top - margin.bottom;

    //setting the user defined colorPallete
    var z = d3.scale.linear()
    .range(["#C2E3A9","#73C03C"]);

    data = presets.dataset;

    //get the keys of enitre data
    keys = d3.keys(data[0]);

     var SeriesKey
    //fetch the XCordinate dynamically or given in presets
    for(var i=0; i<=presets.dimensions.length-1; i++){
        if(presets.dimensions[i].axis === 1){
            XAxisKey = presets.dimensions[i].value.replace(/[{}]/g, '');
        }
        if(presets.dimensions[i].axis === 2 ){
            SeriesKey = presets.dimensions[i].value.replace(/[{}]/g, '');
        }        
    }

    if(SeriesKey)  { // if a series key i.e, axis : 2 is specified in data then
        keys.map(function(key) {        
            if (key !== XAxisKey && key !== SeriesKey) {
                datasets.push(key);
            } 
            else {
                return;
            }
        });
        var array = [];

        data.forEach(function(d) {
            datasets.forEach(function(name){
                array.push(d[SeriesKey]);   //push out the series values as one array
                arr.push(Number(d[name])); //create an array of all values to use on y-axis scale to range specification
                d.name = d[SeriesKey];
                d.key = d[XAxisKey];
                d.value = +Number(d[name]);
                delete d[XAxisKey];
                delete d[name];
                delete d[SeriesKey];
            });        
        });
        ///group based on xAxisKey
        var remapdata = d3.nest()
                .key(function(d){ return d["key"]})
                .entries(data);

        //function to check for duplicates
        Array.prototype.contains = function(v) {
            for(var i = 0; i < this.length; i++) {
                if(this[i] === v) return true;
            }
            return false;
        };

        Array.prototype.unique = function() {
            var arr = [];
            for(var i = 0; i < this.length; i++) {
                if(!arr.contains(this[i])) {
                    arr.push(this[i]);
                }
            }
            return arr; 
        }
        seriesValues = array.unique(); //avoid duplicates

        //re-assign it to data
        data = remapdata;

        avg = d3.sum(arr) / arr.length;
    }
    else{
        //seperate Y-Axis Keys from others
        datasets = d3.keys(data[0]).filter(function(d){ return d!== XAxisKey;})

        // Coerce the JSON data to the appropriate types.
        data.forEach(function(d) {
            datasets.forEach(function(name){
                d.key = d[XAxisKey];
                d.value = +Number(d[name]);
                delete d[XAxisKey];
                delete d[name];
            })        
        });

        avg = d3.sum(data, function(d){
                return d.value; 
                }) / data.length;
    }    

   //initialize scales
    xExtent = data.map(function(d) {
        return d["key"];
    });    

    x = d3.scale.ordinal().rangeRoundBands([0, width], 0.005).domain(xExtent); //Actual x-Axis Scale
    y = d3.scale.linear().range([height, 0], 0.05);
    x1 = d3.scale.ordinal().domain(seriesValues).rangeRoundBands([10, x.rangeBand()], 0.1);

    // Compute the scale domains.
    y.domain([0, d3.max(arr)]);
    z.domain([0, d3.max(data, function(d) { return d3.max(d.values, function(v){ return v.value;}) })]);  

    //find the maximum value in tens / hundreds / thousands
    var yStep = 100;

  // For example, the y-bucket 3200 corresponds to values [3200, 3300]. 
    y.domain([y.domain()[0], y.domain()[1] + yStep]);

    //initialize svg
    svg = d3.select("#" + chart).append('svg')
        .attr("width", BBox.width)
        .attr("height", h)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    //title of the chart
    svg.append("text")
        .attr("x", 0)             
        .attr("y", -(margin.top) /3) 
        .style("font-size", "20px")
        .style("font-weight", "bolder")
        .text(presets.title.text);

    chartWrapper = svg.append('g').attr("class", "chartWrapper");    

    var set = chartWrapper.selectAll(".tile")
                  .data(data)
                .enter().append("g")
                  .attr("class", "tile")

    if(SeriesKey){
        set.selectAll(".heat-tile")
            .data(function(d, i) { return d.values })
        .enter()
            .append("rect")
            .attr("class", "heat-tile")
            .style("fill", function(d) { return z(d.value); })
            .attr("x", function(d) { return x(d.key); })
            .attr("y", function(d) { return y(d.value + x1.rangeBand());} )
            .attr("width", x.rangeBand())
            .attr("height",  height/seriesValues.length)

    } 
    else{
        chartWrapper.selectAll(".tile")
            .append("rect")
            .attr("class", "heat-tile")
            .style("fill", function(d) { return z(d.value); })
            .attr("x", function(d) { return x(d.key); })
            .attr("y", y(avg +yStep) )
            .attr("width", x.rangeBand())
            .attr("height",  y(0) - y(yStep))


        chartWrapper.selectAll(".tile")
            .append("text")
            .attr("class", "text")
            .attr("x", function(d) { return x(d["key"])+x.rangeBand()/2; })
            .attr("y", height / 2)            
            .text(function(d) { return d["key"]; });
    }             
    
//create legend
   if(z.domain()[1]){
    var legend = svg.selectAll(".legend")
      .data(z.ticks(4).reverse())
    .enter().append("g")
      .attr("class", "legend")
      .attr("transform", function(d, i) { return "translate(" + (width + 20) + "," + (20 + i * 20) + ")"; });

      legend.append("rect")
          .attr("width", 20)
          .attr("height", 20)
          .style("fill", z);

      legend.append("text")
          .attr("x", 26)
          .attr("y", 10)
          .attr("dy", ".35em")
          .text(String);
    }
   else{
    //set a dummy domain if values is 0. to render one legend set
    z.domain([z.domain()[0], z.domain()[1] + 0.5]); 

    var legend = svg.selectAll(".legend")
      .data(z.ticks(1).reverse())
    .enter().append("g")
      .attr("class", "legend")
      .attr("transform", function(d, i) { return "translate(" + (width + 20) + "," + (20 + i * 20) + ")"; });

      legend.append("rect")
          .attr("width", 20)
          .attr("height", 20)
          .style("fill", z);

      legend.append("text")
          .attr("x", 26)
          .attr("y", 10)
          .attr("dy", ".35em")
          .text(String);
      }

   }
 