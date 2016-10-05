function lChart(chart, presets) {
    var svg, data, x0, x1, y, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
        width, height, XAxisKey, SeriesKey, legendSet, keys, datasets = [], data = [], arr = [];

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

    rawdata = presets.dataset;
    //get the keys of enitre data
    keys = d3.keys(rawdata[0]);

    //fetch the XCordinate dynamically or given in presets
    for(var i=0; i<=presets.dimensions.length-1; i++){
        if(presets.dimensions[i].axis === 1){
            var XAxisKeyraw = presets.dimensions[i].value;
            XAxisKey = XAxisKeyraw.replace(/[{}]/g, '');
        }
        if(presets.dimensions[i].axis === 2){
            var seriesKeyraw = presets.dimensions[i].value;
            SeriesKey = seriesKeyraw.replace(/[{}]/g, '');
        }
        
    }
    //fetch the y axis keys apart from x-axis 

    if(SeriesKey)  { // if a series key i.e, axis : 2 is specified in data then
        keys.map(function(key) {        
            if (key !== XAxisKey && key !== SeriesKey) {
                datasets.push(key);
            } 
            else {
                return;
            }
        });

        //create an array of all values to use on y-axis scale to range specification
        datasets.map(function(name){
            rawdata.map(function(d,i){ 
                arr.push(d[name]);
            });
        });

        data = d3.nest()
                .key(function(d){return d[SeriesKey];})
                .key(function(d){return d[XAxisKey]})
                .entries(rawdata);

        data.map(function(d){
            d.values.forEach(function(v,i){
               return d.values[i] = datasets.map(function(name){
                return { 
                    key : v["key"],
                    name : v.values[0][SeriesKey],
                    value: +v.values[0][name]  };
            })
            }) 
        })

       legendSet = data.map(function(d,i){
            return {
                key :d["key"],
                name: d["key"]
            }
        })
    }
    else { //if no series Key specified         

        datasets = d3.keys(rawdata[0]).filter(function(key) { //filter the x-axis
                    if(SeriesKey){
                        return key !== XAxisKey || key !== SeriesKey;
                    }
                    else{
                        return key !== XAxisKey;
                    }
        });

        //create an array of all values to use on y-axis scale to range specification
        datasets.map(function(name){
            rawdata.map(function(d,i){ 
                arr.push(d[name]);
            });
        });

        datasets.map(function(name, i){ //grouping the data if only axis :1 is given
            return data[i] = {
                key : name,
                values: rawdata.map(function(d,i){ 
                    return { 
                        key : d[XAxisKey],
                        name :name,
                        value: +d[name]  };
                    })
                }        
        });

        //legend data manipulation
        legendSet = presets.measures;
        //overWrite with un-braced data values
        legendSet = legendSet.map(function(l) {
            return {
                name: l.name,
                key: l.value.replace(/[{}]/g, '')
            }
        })
    }
    
    //initialize scales
    xExtentraw = rawdata.map(function(d) {
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

    //scaling axis
    x0 = d3.scale.ordinal().rangeRoundBands([10, width], 0.3).domain(xExtent); //Actual x-Axis Scale
    x1 = d3.scale.ordinal().domain(legendSet).rangeRoundBands([10, x0.rangeBand()], 0.1); //Series Scaling on X-Axis 
    y = d3.scale.linear().domain([0, d3.max(arr)]).range([height, 20]); //y-Axis Scale

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
    chartWrapper.append('g').classed('x axis', true);
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

    var lineGens = d3.svg.line()
                  .x(function(d) {
                     return x0(d[0].key);
                  })
                  .y(function(d) {               
                      return  y(d[0].value) 
                  });

     var lineGen = d3.svg.line()
                  .x(function(d) {
                     return x0(d.key);
                  })
                  .y(function(d) {               
                      return  y(d.value) 
                  });


     data.forEach(function(d,i){
        if(SeriesKey) {
            chartWrapper.append('path')
                  .attr("class", "path")
                  .attr('stroke', colors(d.key))
                  .attr('stroke-width', 2)
                  .attr('fill', 'none')                  
                  .attr('d',  lineGens(d.values))
                  .attr("data-legend", d.key);
        }
        else {
            chartWrapper.append('path')
                  .attr("class", "path")
                  .attr('stroke', colors(d.key))
                  .attr('stroke-width', 2)
                  .attr('fill', 'none')                  
                  .attr('d',  lineGen(d.values))
                  .attr("data-legend", function() {
                         var attr; 
                        legendSet.forEach(function(l) {
                            if (l.key === d.key) {
                                attr = l.name
                            }
                        });
                        return attr;
                  });
            }
        
     })

    //create a lengend element of <g> and append to svg
    legend = svg.append("g")
        .attr("class", "legend")
        .attr('transform', 'translate(5,50)');
// console.log(legendSet);
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
        .style("fill", function(d, i) { //console.log(d);
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