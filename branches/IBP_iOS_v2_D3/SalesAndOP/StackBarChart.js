function vSChart(chart, presets) {
    var svg, data, x0, x1, y, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
        width, height, XAxisKey, SeriesKey, legendSet, keys, datasets = [],
        data = [],
        arr = [];

    //get the DOM Factors(width & Height) where this chart will be rendered
    var BBox = d3.select("#" + chart).node().getBoundingClientRect();

    var h = .45 * BBox.width; //Calculated height for window based on width fetched from "BBox"

    //configs of the svg to be rendered
    margin = {
        top: 0.05 * BBox.width,
        right: 0.18 * BBox.width,
        bottom: 0.03 * BBox.width,
        left: 0.03 * BBox.width
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
    for (var i = 0; i <= presets.dimensions.length - 1; i++) {
        if (presets.dimensions[i].axis === 1) {
            var XAxisKeyraw = presets.dimensions[i].value;
            XAxisKey = XAxisKeyraw.replace(/[{}]/g, '');
        }
        if (presets.dimensions[i].axis === 2) {
            var seriesKeyraw = presets.dimensions[i].value;
            SeriesKey = seriesKeyraw.replace(/[{}]/g, '');
        }

    }

    //fetch the y axis keys apart from x-axis 
    if (SeriesKey) { // if a series key i.e, axis : 2 is specified in data then

        //seperate Y-Axis Keys from others
        keys.map(function(key) {
            if (key !== XAxisKey && key !== SeriesKey) {
                datasets.push(key);
            } else {
                return;
            }
        });

        //create an array of all values to use on y-axis scale to range specification
        datasets.map(function(name) {
            rawdata.map(function(d, i) {
                arr.push(d[name]);
            });
        });
        
        //Javascript for avoiding duplicate values in an array
        Array.prototype.contains = function(v) {
            for (var i = 0; i < this.length; i++) {
                if (this[i] === v) return true;
            }
            return false;
        };

        Array.prototype.unique = function() {
            var arr = [];
            for (var i = 0; i < this.length; i++) {
                if (!arr.contains(this[i])) {
                    arr.push(this[i]);
                }
            }
            return arr;
        }        

        //legend data manipulation
        legendSet = presets.measures;
        //overWrite with un-braced data values
        legendSet = legendSet.map(function(l) {
            return {
                name: l.name,
                key: l.value.replace(/[{}]/g, '')
            }
        })

        //fetch the seriesKey Key values
        var _keys = rawdata.map(function(d, i) {
            return d[SeriesKey];
        })
        _keys = _keys.unique(); //Unify if any duplicates

        //data re-map y chaging the key names
        for (var i = 0; i < rawdata.length; i++) {
            legendSet.map(function(name) {
                rawdata[i][rawdata[i][SeriesKey]] = rawdata[i][name.key];
                delete rawdata[i][name.key];
                delete rawdata[i][SeriesKey];
            })
        }
        //nesting based on X-Axis Key
        _data = d3.nest()
            .key(function(d) {
                return d[XAxisKey]
            })
            .entries(rawdata);

        //create a data object with keys
        data = _data.map(function(d) {
            return {
                key: d["key"]
            }
        })

        //remap data 
        data.map(function(d) {
            _data.map(function(v) {
                var values = v.values
                for (var i = 0; i <= values.length - 1; i++) {
                    if (d.key === values[i][XAxisKey]) {
                        _keys.map(function(name) {
                            if (values[i][name] !== undefined) {
                                d[name] = values[i][name]
                            }
                        })
                    }
                }
            })
        })
          
        //initialize scales
        xExtent = data.map(function(d) {
            return d["key"];
        });  
                   
        //Stack the layers d3 factor
        var layers = d3.layout.stack()(_keys.map(function(c) {
            return data.map(function(d) {
              return {x: d.key, y: d[c], key: c};
            });
          }));
    }

    //scaling axis
    x0 = d3.scale.ordinal().rangeRoundBands([0, width], 0.3).domain(xExtent); //Actual x-Axis Scale
    x1 = d3.scale.ordinal().domain(legendSet).rangeRoundBands([10, x0.rangeBand()], 0.1); //Series Scaling on X-Axis 
    y = d3.scale.linear().rangeRound([height, 0]).domain([0, d3.max(layers[layers.length - 1], function(d) { return d.y0 + d.y; })]).nice(); //y-Axis Scale

    //initialize axis and formatting
    xAxis = d3.svg.axis().orient('bottom');
    yAxis = d3.svg.axis().orient('left').ticks(5);
    var yFormat = d3.format('.2s');

    //initialize svg
    svg = d3.select("#" + chart).append('svg')
        .attr("width", BBox.width)
        .attr("height", h)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
     var borderPath = svg.append("rect")
                          .attr("x", 0)
                          .attr("y", 0)
                          .attr("height", height)
                          .attr("width", width)
                          .style("stroke", "#C2C2C2")
                          .style("fill", "none")
                          .style("stroke-width", "1");
    svg.append("text")
        .attr("x", margin.left*3)             
        .attr("y", 0 - (margin.top / 2))
        .attr("text-anchor", "middle")  
        .style("font-size", "20px")
        .style("font-weight", "bolder")
        .text(presets.title.text);

    chartWrapper = svg.append('g').attr("class", "chartWrapper");
    chartWrapper.append('g').classed('x axis', true);
    chartWrapper.append('g').classed('y axis', true);

        //Axis Ticks
    xAxis.scale(x0).tickSize(2);
    yAxis.scale(y).tickSize(1).tickFormat(yFormat);

    //Append x-Axis to svg
    svg.select('.x.axis')
        .attr('transform', 'translate(0,' + (height) + ')')
        .call(xAxis);

    //Append y-Axis to svg
    svg.select('.y.axis')
        // .attr('transform', 'translate(' + (margin.left / 2) + ',' + 0 + ')')
        .call(yAxis);

    //draw y lines inside the chart
    svg.selectAll(".y >.tick > line")
        .attr("x2", width);

    //Create .Layers to each series object
    var layer = chartWrapper.selectAll(".layer")
        .data(layers)
        .enter().append("g")
        .attr("class", "layer")
        .style("fill", function(d, i) {
            return colors(i);
        })
        .attr("data-legend", function(d){
            var value;
            _keys.map(function(k,i){
               if(d[0].key === k){
                 value =  k;
                }
            })
            return value;
      });

    //To each .Layer,  render a rectangle against x-Key and Y-key
    layer.selectAll("rect")
      .data(function(d) { return d; })
    .enter().append("rect")
      .attr("x", function(d) { return x0(d.x); })
      .attr("y", function(d) { return y(d.y + d.y0); })
      .attr("height", function(d) { return y(d.y0) - y(d.y + d.y0); })
      .attr("width", x1.rangeBand() - 1);


    //create a lengend element of <g> and append to svg
    legend = svg.append("g")
        .attr("class", "legend")
        .attr('transform', 'translate(10,50)');
   
    //draw legend factors fetching data from the given elements
    legend.selectAll('rect')
        .data(_keys)
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
            return colors(i)
        })
     //append text at each item level   
    legend.selectAll('.legend-item')
        .append("text")
        .attr('x', width + 12)
        .attr('y', function(d, i) {
            return i * 15 + 9;
        })
        .text(function(d, i) {
            return d
        });
}