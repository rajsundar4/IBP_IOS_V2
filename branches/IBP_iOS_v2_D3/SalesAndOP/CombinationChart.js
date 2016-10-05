function CombiationChart(chart, presets) {
    var svg, data, x, y, yB, yL, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
        width, height, XAxisKey, keys, datasets, barSet = [], lineSet =[], yBvalue = [], yLvalue = [];

    //get the DOM Factors(width & Height) where this chart will be rendered
    var BBox = d3.select("#" + chart).node().getBoundingClientRect();

    var h = .45 * BBox.width; //Calculated height for window based on width fetched from "BBox"

    //configs of the svg to be rendered
   margin = {
        top: 0.05 * BBox.width,
        right: 0.18 * BBox.width,
        bottom: 0.03 * BBox.width,
        left: 0.05 * BBox.width
    }
    width = BBox.width - margin.left - margin.right,
        height = h - margin.top - margin.bottom;

    //setting the user defined colorPallete
    var colors = d3.scale.ordinal()
        .range(presets.plotArea.colorPalette);

    data = presets.dataset;

    //fetch the XCordinate dynamically or given in presets
    for(var i=0; i<=presets.dimensions.length-1; i++){
        if(presets.dimensions[i].axis === 1){
            XAxisKey = presets.dimensions[i].value.replace(/[{}]/g, '');
        }
        if(presets.dimensions[i].axis === 2){
            seriesKey = presets.dimensions[i].value.replace(/[{}]/g, '');
        }        
    }

    //legend data manipulation
    legendSet = presets.measures;
    //overWrite with un-braced data values
    legendSet = legendSet.map(function(l,i) {
        if(i===0){
            return {
            name: l.name,
            key: l.value.replace(/[{}]/g, ''),
            type:"Bar"
        }
    }
        if(i===1){
            return {
            name: l.name,
            key: l.value.replace(/[{}]/g, ''),
            type:"Line"
        }
        }
        
    })

    data.map(function(d,i){
        yBvalue.push(d[legendSet[0]["key"]]);
        yLvalue.push(d[legendSet[1]["key"]])
        barSet[i] = {
            key : d[XAxisKey],
            value : +d[legendSet[0]["key"]]
        }
        lineSet[i] = {
            key : d[XAxisKey],
            value : +d[legendSet[1]["key"]]
        }
    })
    
    //initialize scales
    xExtentraw = data.map(function(d) {
        return d["" + XAxisKey + ""];
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
    xExtent = xExtentraw.unique();

    x = d3.scale.ordinal().rangeRoundBands([10, width], 0.3).domain(xExtent); //Actual x-Axis Scale
    y = d3.scale.linear().range([height, 20]).domain([0, d3.max([d3.max(yBvalue), d3.max(yLvalue)])]); //y-Axis BAR Scale
    yB = d3.scale.linear().range([height, 20]).domain([0, d3.max(yBvalue)]); //y-Axis BAR Scale
    yL = d3.scale.linear().range([height, 20]).domain([0, d3.max(yLvalue)]); //y-Axis LINE Scale

    //initialize axis and formatting
    xAxis = d3.svg.axis().orient('bottom');
    yAxis = d3.svg.axis().orient('left');
     var yFormat = d3.format('.1s');

    //initialize svg
    svg = d3.select("#" + chart).append('svg')
        .attr("width", BBox.width)
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

    //Append heading 
    // svg.append("text")
    //     .attr("x", margin.left*3)             
    //     .attr("y", 0 - (margin.top / 2))
    //     .attr("text-anchor", "middle")  
    //     .style("font-size", "20px")
    //     .style("font-weight", "bolder")
    //     .text(presets.title.text);

    chartWrapper = svg.append('g').attr("class", "chartWrapper");
    chartWrapper.append('g').classed('x axis', true)
    chartWrapper.append('g').classed('y axis', true);

    //Axis Ticks
    xAxis.scale(x).tickSize(2);
    yAxis.scale(y)
        .tickFormat(yFormat)
        .innerTickSize(-width)
        .outerTickSize(0)
        .tickPadding(10)
        .ticks(6);

     //Append x-Axis to svg
    svg.select('.x.axis')
        .attr('transform', 'translate(0,' + (height) + ')')
        .call(xAxis);

    //Append y-Axis to svg
    svg.select('.y.axis')
        .call(yAxis);

    var set = svg.select("g.chartWrapper").selectAll(".dataset")
            .data(barSet)
            .enter().append("g")
            .attr("class", "dataset")
            .attr("transform", function(d, i) { 
                return "translate(" + (x(d["key"])) + "," + 0 + ")";
            })

    //create rect and render y-values.
         set.append("rect")
            .attr("width", x.rangeBand())
            .attr("x", function(d) {
                return x(d.name);
            })
            .attr("y", function(d) { return yB(d.value); })
            .attr("height", function(d) { return height - yB(d.value); })
            .style("fill", function(d,i) {
                return colors(d);
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
        var lineGen = d3.svg.line()
              .x(function(d) { 
                 return x(d.key) + x.rangeBand()/2;
              })
              .y(function(d) {               
                  return  yL(d.value) 
              });

        chartWrapper.append('path')
            .datum(lineSet)
                  .attr("class", "path")
                  .attr('stroke', function(d,i){ return colors(i)})
                  .attr('stroke-width', 2)
                  .attr('fill', 'none')                  
                  .attr('d',  lineGen)
                  .attr("data-legend", function(d) {
                         var attr; 
                        legendSet.forEach(function(l) {
                            if (l.key === d.key) {
                                attr = l.name
                            }
                        });
                        return attr;
                  });

        chartWrapper.selectAll("dot")
        .data(lineSet)
        .enter().append("circle")
        .attr('fill', function(d,i){  return colors(0)})
        .attr('stroke', function(d,i){ return colors(0)})
        .attr("r", 3)
        .attr("cx", function(d) { return x(d.key) + x.rangeBand()/2; })
        .attr("cy", function(d) { return yL(d.value); })


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
        .each(function(d,i){
            if(d.type=== "Bar"){
                d3.select(this)
                  .append("rect")
                  .attr("x", width)
                  .attr("y", function(d, i) { console.log(d);
                        return i * 15;
                  })
                  .attr("width", 10)
                  .attr("height", 10)
                  .style("fill", function(d, i) {
                        return colors(d)
                  })
            }
            if(d.type=== "Line"){
                d3.select(this)
                  .append("circle")
                  .attr("x", width)
                  .attr("y", function(d, i) { 
                        return i * 15;
                  })
                  .attr("r", 5)
                  .attr("cx", width + 5)
                  .attr("cy", 20)
                  .style("fill", function(d, i) {
                        return colors(i)
                  })
            }
        })
        // if(d.type=== "Bar"){
            
        
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

/*function CombiationChart(chart, presets) {
    var svg, data, x0, x1, y, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
        width, height, XAxisKey, keys, datasets;

    //get the DOM Factors(width & Height) where this chart will be rendered
    var BBox = d3.select("#" + chart).node().getBoundingClientRect();

    var h = .45 * BBox.width; //Calculated height for window based on width fetched from "BBox"

    //configs of the svg to be rendered
   margin = {
        top: 0.05 * BBox.width,
        right: 0.18 * BBox.width,
        bottom: 0.03 * BBox.width,
        left: 0.05 * BBox.width
    }
    width = BBox.width - margin.left - margin.right,
        height = h - margin.top - margin.bottom;

    //setting the user defined colorPallete
    var colors = d3.scale.ordinal()
        .range(presets.plotArea.colorPalette);

    data = presets.dataset;
    //get the keys of enitre data
    keys = d3.keys(data[0]);

    //legend data manipulation
    legendSet = presets.measures;
    //overWrite with un-braced data values
    legendSet = legendSet.map(function(l) {
        return {
            name: l.name,
            key: l.value.replace(/[{}]/g, '')
        }
    })

    var SeriesKey  = [];
    //fetch the XCordinate dynamically or given in presets
    for(var i=0; i<=presets.dimensions.length-1; i++){
        if(presets.dimensions[i].axis === 1){
            var XAxisKeyraw = presets.dimensions[i].value;
            XAxisKey = XAxisKeyraw.replace(/[{}]/g, '');
        }
        if(presets.dimensions[i].axis === 2 ){
            SeriesKey[i-1] = presets.dimensions[i].value.replace(/[{}]/g, '');
        }        
    }
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

    console.log(data)
    //initialize scales
    xExtent = data.map(function(d) {
        return d["" + XAxisKey + ""];
    });

    //scaling axis
    x0 = d3.scale.ordinal().rangeRoundBands([10, width], 0.3).domain(xExtent); //Actual x-Axis Scale
    x1 = d3.scale.ordinal().domain(datasets).rangeRoundBands([10, x0.rangeBand()], 0.1); //Series Scaling on X-Axis 
    y = d3.scale.linear().rangeRound([height, 0]).domain([0, d3.max(data, function(d) {
        return d3.max(d.values, function(d) {
            return d.value;
        })
    })]).nice(); //y-Axis Scale

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
    //chart border
    svg.append("rect")
       .attr("x", 0)
       .attr("y", 0)
       .attr("height", height)
       .attr("width", width)
       .style("stroke", "#C2C2C2")
       .style("fill", "none")
       .style("stroke-width", "1");    
    //Append heading 
    svg.append("text")
        .attr("x", margin.left*3)             
        .attr("y", 0 - (margin.top / 2))
        .attr("text-anchor", "middle")  
        .style("font-size", "20px")
        .style("font-weight", "bolder")
        .text(presets.title.text);

    chartWrapper = svg.append('g').attr("class", "chartWrapper");
    chartWrapper.append('g').classed('x axis', true)
    chartWrapper.append('g').classed('y axis', true);

    //Axis Ticks
    xAxis.scale(x0).tickSize(2);
    yAxis.scale(y)
        .tickFormat(yFormat)
        .innerTickSize(-width)
        .outerTickSize(0)
        .tickPadding(10)
        .ticks(5);

    //Append x-Axis to svg
    svg.select('.x.axis')
        .attr('transform', 'translate(0,' + (height) + ')')
        .call(xAxis);

    //Append y-Axis to svg
    svg.select('.y.axis')
        .call(yAxis);

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
            .data(function(d, i) { console.log(d.values[0])
                return d.values[0]
            })
            .enter()
            .append("rect")
            // .attr("width", x1.rangeBand())
            .attr("x", function(d) { console.log(d)
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
}*/