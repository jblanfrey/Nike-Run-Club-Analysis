function app()
  
  fig = uifigure;
  fig.Name = "Run viewer";
  
  m = uimenu(fig,'Text','&Export');
  
  mitem = uimenu(m,'Text','&Export to .gpx');
  mitem.Accelerator = 'E';
  mitem.MenuSelectedFcn = @MenuSelected;
  
  gridLayout = uigridlayout(fig, [2,2]);
  gridLayout.RowHeight = {80, "1x"};
  gridLayout.ColumnWidth = {150, "1x"};
  
  controllerPanel = uipanel(gridLayout);
  controllerPanel.Layout.Row = [1 2];
  controllerPanel.Layout.Column = 1;
  
  summaryPanel = uipanel(gridLayout);
  summaryPanel.Layout.Row = 1;
  summaryPanel.Layout.Column = 2;
  
  geoaxesPanel = uipanel(gridLayout);
  geoaxesPanel.Layout.Row = 2;
  geoaxesPanel.Layout.Column = 2;
  
  % Model
  act = activity;
  % Controller
  Controller = activityController(controllerPanel, act);
  % Summary Viewer
  summaryViewer = activitySummaryViewer(summaryPanel, act);
  % Map Viewer
  mapViewer = activityMapViewer(geoaxesPanel, act);
  
  function MenuSelected(~, ~)
    act.exportToGPX;
  end
  
end

