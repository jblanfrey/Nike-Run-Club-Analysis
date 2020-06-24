function app()
  ds = fileDatastore("data", "ReadFcn",@load);
  fig = uifigure;
  gridLayout = uigridlayout(fig, [3,2]);
  gridLayout.RowHeight = {30, 30, "1x"};
  gridLayout.ColumnWidth = {150, "1x"};
  
  listOfFiles = ds.Files;
  listOfFiles = extractBetween(listOfFiles, "activity-", ".mat");
  fileList = uilistbox(gridLayout, 'Items', listOfFiles, 'ValueChangedFcn', @updateEditField);
  fileList.Layout.Row = [1 3];
  fileList.Layout.Column = 1;
  
  activityTitle = uilabel(gridLayout);
  activityTitle.Layout.Row = 1;
  activityTitle.Layout.Column = 2;
  activityTitle.Text = "";
  activityTitle.HorizontalAlignment = "center";
  activityTitle.FontWeight = "bold";
  activityTitle.FontSize = 16;
  
  activityLabel = uilabel(gridLayout);
  activityLabel.Layout.Row = 2;
  activityLabel.Layout.Column = 2;
  activityLabel.Text = "";
  activityLabel.HorizontalAlignment = "center";
  
  geoaxesPanel = uipanel(gridLayout);
  geoaxesPanel.Layout.Row = 3;
  geoaxesPanel.Layout.Column = 2;
  geoplotAxis = geoaxes(geoaxesPanel);
    
  % ValueChangedFcn callback
  function updateEditField(src,event)
    v = activityViewer("activity-" + src.Value + ".mat");
    v.plotActivityMap(geoplotAxis);
    activityTitle.Text = v.Activity.NickName + " - " + string(v.Activity.Date);
    s = v.Activity.Summary;
    t = milliseconds(v.Activity.DurationMS);
    t.Format="hh:mm:ss";
    pace = minutes(s.value(s.metric=="pace"));
    pace.Format = "mm:ss";
    activityLabel.Text = "Distance: " + s.value(s.metric=="distance") + " km - " + ... 
      "Average pace: " + string(pace) + " min/km - " + ...
      "Time: " + string(t);
  end
end
