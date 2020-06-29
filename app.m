function app()
  ds = fileDatastore("data", "ReadFcn",@load);
  fig = uifigure;
  gridLayout = uigridlayout(fig, [2,2]);
  gridLayout.RowHeight = {80, "1x"};
  gridLayout.ColumnWidth = {150, "1x"};
  
  listOfFiles = ds.Files;
  listOfFiles = extractBetween(listOfFiles, "activity-", ".mat");
  fileList = uilistbox(gridLayout, 'Items', listOfFiles, 'ValueChangedFcn', @updateEditField);
  fileList.Layout.Row = [1 2];
  fileList.Layout.Column = 1;
  
  summaryPanel = uipanel(gridLayout);
  summaryPanel.Layout.Row = 1;
  summaryPanel.Layout.Column = 2;
  
  geoaxesPanel = uipanel(gridLayout);
  geoaxesPanel.Layout.Row = 2;
  geoaxesPanel.Layout.Column = 2;
  
  % Model
  act = activity;
  % Summary Viewer
  summaryViewer = activitySummaryViewer(summaryPanel, act);
  % Map Viewer
  mapViewer = activityMapViewer(geoaxesPanel, act);
    
  % ValueChangedFcn callback
  function updateEditField(src,~)
    act.updateActivity("activity-" + src.Value + ".mat");
  end
end
