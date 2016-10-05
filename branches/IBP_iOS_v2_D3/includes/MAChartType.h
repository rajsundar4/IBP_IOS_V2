/*
 
 Copyright (c) SAP AG. 2011  All rights reserved.                                   
 
 In addition to the license terms set out in the SAP License Agreement for 
 the SAP Mobile Platform ("Program"), the following additional or different 
 rights and accompanying obligations and restrictions shall apply to the source 
 code in this file ("Code").  SAP grants you a limited, non-exclusive, 
 non-transferable, revocable license to use, reproduce, and modify the Code 
 solely for purposes of (i) maintaining the Code as reference material to better
 understand the operation of the Program, and (ii) development and testing of 
 applications created in connection with your licensed use of the Program.  
 The Code may not be transferred, sold, assigned, sublicensed or otherwise 
 conveyed (whether by operation of law or otherwise) to another party without 
 SAP's prior written consent.  The following provisions shall apply to any 
 modifications you make to the Code: (i) SAP will not provide any maintenance
 or support for modified Code or problems that result from use of modified Code;
 (ii) SAP expressly disclaims any warranties and conditions, express or 
 implied, relating to modified Code or any problems that result from use of the 
 modified Code; (iii) SAP SHALL NOT BE LIABLE FOR ANY LOSS OR DAMAGE RELATING
 TO MODIFICATIONS MADE TO THE CODE OR FOR ANY DAMAGES RESULTING FROM USE OF THE 
 MODIFIED CODE, INCLUDING, WITHOUT LIMITATION, ANY INACCURACY OF DATA, LOSS OF 
 PROFITS OR DIRECT, INDIRECT, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES, EVEN
 IF SAP HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES; (iv) you agree 
 to indemnify, hold harmless, and defend SAP from and against any claims or 
 lawsuits, including attorney's fees, that arise from or are related to the 
 modified Code or from use of the modified Code. 
 
 */

/*
 *  MAChartType.h
 *  MAMetaData
 *
 *  Created by andersk on 2010-02-23.
 *  Copyright 2010 SAP AG. All rights reserved.
 *
 */

typedef enum
{
	/// <summary>
	/// chart type None
	/// </summary>
	MAChartTypeNone = 0,
	/// <summary>
	/// Chart type Bar
	/// </summary>
	MAChartTypeBar = 1,
	/// <summary>
	/// Chart type Column
	/// </summary>
	MAChartTypeColumn = 2,
	/// <summary>
	/// Chart type Line (with data points)
	/// </summary>
	MAChartTypeLine = 3, 
	/// <summary>
	/// Chart type Area
	/// </summary>
	MAChartTypeArea = 4,
	/// <summary>
	/// Chart type Pie
	/// </summary>
	MAChartTypePie = 5,
	/// <summary>
	/// Chart type Gauge
	/// </summary>
	MAChartTypeGauge = 6,
	/// <summary>
	/// Chart type StackedBar
	/// </summary>
	MAChartTypeStackedBar = 7,
	/// <summary>
	/// Chart type StackedColumn
	/// </summary>
	MAChartTypeStackedColumn = 8,
	/// <summary>
	/// Chart type StackedLine
	/// </summary>
	MAChartTypeStackedLine = 9,
	/// <summary>
	/// Chart type StackedArea
	/// </summary>
	MAChartTypeStackedArea = 10,
	/// <summary>
	/// Chart type Scatter
	/// </summary>
	MAChartTypeScatter = 11,
	/// <summary>
	/// Chart type Bubble
	/// </summary>
	MAChartTypeBubble = 12,
	/// <summary>
	/// Chart type Horizontal Bullet
	/// </summary>
	MAChartTypeHorizontalBullet = 13,
	/// <summary>
	/// Chart type Vertical Bullet
	/// </summary>
	MAChartTypeVerticalBullet = 14,
	/// <summary>
	/// Chart type Candlestick
	/// </summary>
	MAChartTypeCandlestick = 15,
	/// <summary>
	/// Chart type Sparkline
	/// </summary>
	MAChartTypeSparkline = 16,
	/// <summary>
	/// Chart type DataGrid
	/// </summary>
	MAChartTypeDataGrid = 17,
	/// <summary>
	/// Chart type Radar
	/// </summary>
	MAChartTypeRadar = 18,
	/// <summary>
	/// Chart type Filled Radar
	/// </summary>
	MAChartTypeFilledRadar = 19,
	/// <summary>
	/// Chart type Treemap
	/// </summary>
	MAChartTypeTreemap = 20,
	/// <summary>
	/// grouping type, chart is first in a list
	/// </summary>
	MAChartTypeGroupDrilldown = 21,
	/// <summary>
	/// grouping type, chart is first in a list
	/// </summary>
	MAChartTypeGroupZooming = 22,
	/// <summary>
	/// grouping type, chart is first in a list
	/// </summary>
	MAChartTypeGroupOverlay = 23,
	/// <summary>
	/// grouping type for tree levels, use levelAt to retrieve charts
	/// </summary>
	MAChartTypeGroupTreeMap = 24,
    /// <summary>
	/// Rich Format Table
	/// </summary>
	MAChartTypeRFTable = 25,
    /// <summary>
	/// Chart type Line (without data points)
	/// </summary>
	MAChartTypeLineSimple = 26,
    
    /// <summary>
	/// Number of chart types. Must be at end of enum
	/// </summary>
    MAChartTypeMax

}  MAChartType;

/**
 Chart Layer Types, which can be used in mixed-type charts, such as Overlay and Rich Format(RF) Tables 
 */
typedef enum
{
    /// <summary>
	/// Layer types for Overlay charts
	/// </summary>
    MAChartLayerTypeBar = MAChartTypeBar,
    MAChartLayerTypeColumn = MAChartTypeColumn,
	MAChartLayerTypeLine = MAChartTypeLine,
    MAChartLayerTypeLineSimple =  MAChartTypeLineSimple,
	MAChartLayerTypeArea = MAChartTypeArea,
	MAChartLayerTypeStackedBar = MAChartTypeStackedBar,
	MAChartLayerTypeStackedColumn = MAChartTypeStackedColumn,
	MAChartLayerTypeStackedLine = MAChartTypeStackedLine,
	MAChartLayerTypeStackedArea = MAChartTypeStackedArea,
    
    /// <summary>
	/// Layer types for RFTable
	/// </summary>
    MAChartLayerTypeRFTableData = MAChartTypeMax + 1,
    MAChartLayerTypeRFTableChart = MAChartTypeMax + 2,
    MAChartLayerTypeRFTableVariance = MAChartTypeMax + 3
} MAChartLayerType;

