function DonutChart(chart, presets) {
    var svg, data, r, w, h, chartWrapper, line, path, margin = {},
    width, height, keys, datasets, arr = [], yValue = [], nullValues = [];
    
    //get the DOM Factors(width & Height) where this chart will be rendered
    w = Number(presets.width)
    
    h = Number(presets.height)
    //configs of the svg to be rendered
    margin = {
    top: 15,
    right: 0.20 * w,
    bottom: 0.06 * w,
    left: 0.18 * w
    }
    width = w - margin.left - margin.right;
    height = h - margin.top - margin.bottom;
    
    
    if(w <= 243.5 && h <= 265.6){
        r = h/3.5;
    }
    else{
        r = h/2;
    }
    
    
    //setting the user defined colorPallete
    var colors = d3.scale.ordinal()
    .range(presets.plotArea.colorPalette);
    
    data = presets.dataset;
    
    //fetch the XCordinate dynamically or given in presets
    var XAxisKeyraw = presets.dimensions[0].value;
    XAxisKey = XAxisKeyraw.replace(/[{}]/g, '');
    
    var dLeg = d3.nest()
    .key(function(d){return d[XAxisKey] })
    .entries(data)
    
    
    
    //legend data manipulation
    var legendSet = presets.measures;
    //overWrite with un-braced data values
    legendSet = legendSet.map(function(l) {
                              return {
                              name: l.name,
                              key: l.value.replace(/[{}]/g, '')
                              }
                              })
    
    data.map(function(d){
             legendSet.forEach(function(v){
                               if(isNaN(Number(d[v["key"]]))){
                               d[v["key"]] = 0;
                               }
                               arr.push(Number(d[v["key"]]));
                               })
             })
    
    //initialize svg
    svg = d3.select("#" + chart).append('svg')
    .data([data])
    .attr("width", w)
    .attr("height", h)
    .append("g")
    .attr("transform", "translate(" + (w / 3 ) + "," + (h/2 ) + ")");
    
    chartWrapper = svg.append('g').attr("class", "chartWrapper");
    chartWrapper.append('g').data(data).enter();
    
    arr.forEach(function(d) {
                if (d === 0) {
                nullValues.push(d);
                } else {
                yValue.push(d);
                }
                })
    if (yValue.length) {
        
        // svg.append("text")
        // .attr("text-anchor", "middle")
        // .style("font-size", "20px")
        // .style("font-weight", "bolder")
        // .text(presets.title.text);
        
        var innerRadius;
        if(presets.type === "PIE"){
            innerRadius = 0;
        }
        else{
            innerRadius = r-60;
        }
        
        // declare an arc generator function
        var arc = d3.svg.arc()
        .outerRadius(r)
        .innerRadius(innerRadius);
        
        var pie = d3.layout.pie()
        .sort(null)
        .value(function(d){
               var value;
               legendSet.map(function(name){
                             value = d[name["key"]];
                             })
               return value;
               });
        
        // select paths, use arc generator to draw
        var arcs = chartWrapper.selectAll(".slice")
        .data(pie(data))
        .enter()
        .append("g").attr("class", "slice");
        
        //render arcs based on values
        arcs.append("path")
        .attr("d", function (d) {
              return arc(d);
              }).attr("fill", function(d, i){
                      return colors(i);
                      })
        .attr("data-legend", function(d){
              return d.data[XAxisKey];
              })
        //create a lengend element of <g> and append to svg
        legend = svg.append("g")
        .attr("class", "legend")
        .attr('transform', function(d,i){
              return 'translate('+ 0+',' + 0 + ')' ;
              });
        
        //draw legend factors fetching data from the given elements
        legend.selectAll('circle')
        .data(dLeg)
        .enter()
        .append("g")
        .attr("width", "100")
        .attr("height", "50").attr('transform', 'translate(0,0)')
        .attr("class", "legend-item")
        .append("circle")
        .attr("cx",  r + margin.top)
        .attr("cy", function(d, i) {
              return i * 15;
              })
        .attr("r", 5)
        .style("fill", function(d, i) {
               return colors(i)
               })
        legend.selectAll('.legend-item')
        .append("text")
        .attr('x', r + margin.top + 12)
        .attr('y', function(d, i) {
              return i * 15 + 5;
              })
        .text(function(d, i) {
              return d.key
              });
    } else {
        svg.append("text")
        .attr("x", r / 2)
        .attr("y", r / 2)
        .attr("text-anchor", "middle")
        .style("font-size", "14px")
        .text("NO DATA");
    }
}
