function verticleBarChart(chart, presets) {
    var svg, data, x0, x1, y, w, h, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
    width, height, XAxisKey, keys, datasets, arr = [], nullValues = [], yValue = [];
    
    //get the DOM Factors(width & Height) where this chart will be rendered
    w = Number(presets.width)
    
    h = Number(presets.height)
    
    //configs of the svg to be rendered
    margin = {
    top: 15,
    right: 0.20 * w,
    bottom: 0.10 * w,
    left: 0.10 * w
    }
    width = w - margin.left - margin.right;
    height = h - margin.top - margin.bottom;
    
    //setting the user defined colorPallete
    var colors = d3.scale.ordinal()
    .range(presets.plotArea.colorPalette);
    
    data = presets.dataset;
    //get the keys of enitre data
    // keys = d3.keys(data[0]);
    
    //legend data manipulation
    legendSet = presets.measures;
    //overWrite with un-braced data values
    legendSet = legendSet.map(function(l,i) {
                              return {
                              name: l.name,
                              key: l.value.replace(/[{}]/g, ''),
                              // color:colors(l.value.replace(/[{}]/g, ''))
                              }
                              });
    
    var SeriesKey;
    //fetch the XCordinate dynamically or given in presets
    for(var i=0; i<=presets.dimensions.length-1; i++){
        if(presets.dimensions[i].axis === 1){
            var XAxisKeyraw = presets.dimensions[i].value;
            XAxisKey = XAxisKeyraw.replace(/[{}]/g, '');
        }
        if(presets.dimensions[i].axis === 2 ){
            SeriesKey = presets.dimensions[i].value.replace(/[{}]/g, '');
        }
    }
    
    //If Axis :2 is provided at dimensions
    if(SeriesKey){
        //ngrouping based on XAxizKey
        _data = d3.nest()
        .key(function(d){  return d[XAxisKey]   })
        .entries(data);
        
        //remapping the data with proper naming conventions
        for (var i = 0; i < _data.length; i++) {
            values = _data[i].values;
            for(var j=0; j < values.length; j++){
                legendSet.forEach(function(name){
                                  arr.push(Number(values[j][name["key"]]));
                                  values[j] = {
                                  key: values[j][XAxisKey],
                                  name : values[j][SeriesKey],
                                  value: +Number(values[j][name["key"]])
                                  }
                                  })
            }
        }
        
        //resetting the data Object with remapped data
        data =_data;
        //Initialise array for datasets
        datasets = new Array();
        //map the actual Series Values for each gropued data
        for (var i = 0; i < _data.length; i++) {
            values = _data[i].values;
            for(var j=0; j < values.length; j++){
                datasets.push(values[j]["name"])
            }
        }
        
        //initialize scales
        xExtent = data.map(function(d) {
                           return d["key"];
                           });
        
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
        datasets = datasets.unique();
        
        var CustomlegendSet = datasets.map(function(d,i){
                                           return {
                                           key : d,
                                           name : d,
                                           color : colors(d)
                                           }
                                           })
        
    }
    else{
        // //fetch the y axis keys apart from x-axis
        datasets = presets.measures;
        
        // //overWrite with un-braced data values
        datasets = datasets.map(function(l,i) {
                                return   l.value.replace(/[{}]/g, '');
                                });
        
        //mapping (grouping) the data as required to render
        data.forEach(function(d) {
                     d.values = datasets.map(function(name) {
                                             // console.log(name);
                                             arr.push(Number(d[name]));
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
    }
    
    //scaling axis
    x0 = d3.scale.ordinal().rangeRoundBands([10, width], 0.3).domain(xExtent); //Actual x-Axis Scale
    x1 = d3.scale.ordinal().domain(datasets).rangeRoundBands([10, x0.rangeBand()], 0.1); //Series Scaling on X-Axis
    y = d3.scale.linear().rangeRound([height, 0]).domain(d3.extent(arr, function(d) { return d; })).nice(); //y-Axis Scale
    
    if(y.domain()[0] > 0){
        y.domain([0, y.domain()[1]+y.domain()[1]/arr.length])
    }
    //initialize axis and formatting
    xAxis = d3.svg.axis();
    yAxis = d3.svg.axis().orient('left');
    var yFormat = d3.format('.2s');
    
    //initialize svg
    svg = d3.select("#" + chart).append('svg')
    .attr("width", w)
    .attr("height", h)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    
    //chart border
    svg.append("rect")
    .attr("x", 0)
    .attr("y", 0)
    .attr("height", height)
    .attr("width", width)
    .style("stroke", "#C2C2C2")
    .style("fill", "none")
    .style("stroke-width", "1");
    
    arr.forEach(function(d) {
                if (d === 0 || d === NaN || isNaN(d)) {
                nullValues.push(d);
                } else {
                yValue.push(d);
                }
                })
    if (yValue.length) {
        chartWrapper = svg.append('g').attr("class", "chartWrapper");
        chartWrapper.append('g').classed('x axis', true)
        chartWrapper.append('g').classed('y axis', true);
        
        ///Axis Ticks
        var evenOnes = [];
        function splitArray(candid) {
            for(var i=0; i<candid.length; i++)
                if(i % 2 == 0 ){
                    evenOnes.push(candid[i]);
                }
        }
        splitArray(xExtent);
        if(xExtent.length > 8){
            xAxis.tickValues(evenOnes);
        }
        
        xAxis.scale(x0).tickSize(3);
        yAxis.scale(y)
        .tickFormat(yFormat)
        .innerTickSize(-width)
        .outerTickSize(0)
        .tickPadding(10)
        .ticks(6);
        
        // y.ticks(5).map(y.tickFormat(5, "+%"))
        
        function Y0() {
            return y(0);
        }
        
        //Append x-Axis to svg
        var xaxis = svg.select('.x.axis')
        .attr('transform', 'translate(0,' + (height) + ')')
        .call(xAxis.orient('bottom'))
        if(xExtent/length > 4){
            xaxis.selectAll("text")
            .attr("y", 0)
            .attr("x", 9)
            .attr("transform", "rotate(-90)")
            .attr("dx", "-1.2em")
            .attr("dy", ".35em")
            .style("text-anchor", "end");
        }
        
        // zero line
        svg.select(".x.axis.zero")
        .attr("transform", "translate(0," + Y0() + ")")
        .call(xAxis.tickFormat("").tickSize(0));
        
        //Append y-Axis to svg
        svg.select('.y.axis')
        .call(yAxis);
        
        //create groups for each series
        var set = svg.select("g.chartWrapper").selectAll(".dataset")
        .data(data)
        .enter().append("g")
        .attr("class", "dataset")
        .attr("transform", function(d, i) {
              if(SeriesKey){
              return "translate(" + (x0(d["key"])) + "," + 0 + ")";
              }else {
              return "translate(" + (x0(d[XAxisKey])) + "," + 0 + ")";
              }
              
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
              if (isNaN(y(d.value))) {
              return Y0();
              } else {
              return d.value < 0 ? Y0() : y(d.value);
              }
              })
        .attr("height", function(d) {
              if (isNaN(y(d.value))) {
              return 0;
              } else {
              return Math.abs( y(d.value) - Y0() );
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
        .data(function(){
              if(SeriesKey) {
              return CustomlegendSet;
              }
              else {
              return legendSet
              }
              })
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
        // .attr("rx", 2)
        // .attr("ry", 2)
        .style("fill", function(d, i) {console.log(d);
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
    } else {
        svg.append("text")
        .attr("x", width / 2)
        .attr("y", height / 2)
        .attr("text-anchor", "middle")
        .style("font-size", "14px")
        .text("NO DATA");
    }
}