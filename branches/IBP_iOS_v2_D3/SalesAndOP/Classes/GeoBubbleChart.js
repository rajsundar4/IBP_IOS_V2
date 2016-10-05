function GeoBubbleChart(chart, presets) {
    var svg, projection, path, zoom, size = [],
    force, node, r, min, max, avg, legendSet = [], XAxisKey;
    
    //get the DOM Factors(width & Height) where this chart will be rendered
    w = Number(presets.width)
    
    h = Number(presets.height)
    //configs of the svg to be rendered
    margin = {
    top: 15,
    right: 0.10 * w,
    bottom: 0.10 * w,
    left: 20
    }
    width = w - margin.left - margin.right;
    height = h - margin.top - margin.bottom;
    
    //legend data manipulation
    yMeasure = presets.measures;
    //overWrite with un-braced data values
    yMeasure = yMeasure.map(function(l) {
                            return {
                            name: l.name,
                            key: l.value.replace(/[{}]/g, '')
                            }
                            });
    
    //fetch the XCordinate dynamically or given in presets
    for (var i = 0; i <= presets.dimensions.length - 1; i++) {
        if (presets.dimensions[i].axis === 1) {
            XAxisKey = presets.dimensions[i].value.replace(/[{}]/g, '');
        }
    }
    
    data.forEach(function(d){
                 d[yMeasure[0].key] = Number(d[yMeasure[0].key]);
                 if(Number(d[yMeasure[0].key]) === "" || Number(d[yMeasure[0].key]) == "<null>" || isNaN(Number(d[yMeasure[0].key]))){
                 d[yMeasure[0].key] = 0;
                 }
                 });
    console.log(data);
    //initialize svg
    svg = d3.select("#" + chart).append('svg')
    .attr("width", w)
    .attr("height", h)
    
    var g = svg.append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    .style("fill", "#EFEFEF")
    .style("stroke", "#B9B9B9");
    
    
    projection = d3.geo.mercator().scale((width + 1) / 2.5 / Math.PI)
    .translate([width / 2, height / 2])
    .precision(.1);
    
    path = d3.geo.path()
    .projection(projection);
    
    $.ajax({
           type: "GET",
           url: "https://gist.githubusercontent.com/abenrob/787723ca91772591b47e/raw/8a7f176072d508218e120773943b595c998991be/world-50m.json",
           dataType: "json",
           async: false,
           success: function(world) {
           g.selectAll("path")
           .data([topojson.object(world, world.objects.land)])
           .enter().append("path")
           .attr("d", path);
           
           g.selectAll("boundary")
           .data([topojson.object(world, world.objects.countries)])
           .enter().append("path")
           .attr("d", path);
           }
           });
    
    data.forEach(function(d) {
                 size.push(d[yMeasure[0].key]);
                 })
    
    node = g.selectAll(".bubble")
    .data(data)
    .enter().append("g")
    .attr("class", "bubble")
    .attr("id", function(d) {
          return d[XAxisKey];
          })
    
    r = d3.scale.sqrt()
    .domain([0, d3.max(size)])
    .range([0, 15]);
    
    node.append("circle")
    .attr("transform", function(d) {
          var cordinates = [d.GEOLONGITUDE, d.GEOLATITUDE]
          return "translate(" + projection(cordinates) + ")";
          })
    .attr("class", "node")
    .attr('fill', '#748CB2')
    .attr('opacity', 1)
    .attr('fill-opacity', 0.8)
    .attr('r', function(d, i) { var v = d[yMeasure[0].key];
          return r(v) + 2;
          })
    
    var zoom = d3.behavior.zoom()
    .on("zoom", function() {
        g.attr("transform", "translate(" +
               d3.event.translate.join(",") + ")scale(" + d3.event.scale + ")");
        g.selectAll("circle")
        .attr("d", path.projection(projection));
        g.selectAll("path")
        .attr("d", path.projection(projection));
        
        });
    
    svg.call(zoom)
    
    min = d3.min(size);
    max = d3.max(size);
    avg = Math.round(d3.sum(size) / size.length);
    
    var legend = svg.append("g")
    .attr("class", "legend")
    .attr('transform', 'translate(' + (w - margin.right) + ',' + (height - margin.bottom) + ')')
    .selectAll("g")
    .data([max, avg, min])
    .enter().append("g");
    
    legend.append("circle")
    .attr("class","legend-circles")
    .attr("cy", function(d) {
          return -r(d) + 2;
          })
    .attr("r", r);
    
    legend.append("text")
    .attr("y", function(d) {
          return -2.5 * r(d);
          })
    .attr("dy", "1.3em")
    .text(d3.format(".1s"));
    
}