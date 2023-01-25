function fig = BatteryHV_plotInputs(nvpairs)
%% Plots input signals defined in a model
%
% This assumes that the model is loaded.

% Copyright 2022-2023 The MathWorks, Inc.

arguments
  nvpairs.ModelName {mustBeText} = "BatteryHV_harness_model"
  nvpairs.BlockPath_LoadCurrent {mustBeText} = "/Inputs/Load current"
  nvpairs.BlockPath_HeatFlow {mustBeText} = "/Inputs/Heat flow"
  nvpairs.WindowName {mustBeTextScalar} = ""
  nvpairs.Width {mustBePositive, mustBeInteger} = 400
  nvpairs.Height {mustBePositive, mustBeInteger} = 300
  nvpairs.Visible (1,1) matlab.lang.OnOffSwitchState = "on"
end

loadCurrent = nvpairs.ModelName + nvpairs.BlockPath_LoadCurrent;
heatFlow = nvpairs.ModelName + nvpairs.BlockPath_HeatFlow;

curr_dataPoints = get_param(loadCurrent, "dataPoints");
curr_deltaT =  get_param(loadCurrent, "deltaT");

currSignal = SignalDesigner("continuous");
currSignal.XYData = curr_dataPoints;
currSignal.DeltaX = curr_deltaT;

heatflow_dataPoints = get_param(heatFlow, "dataPoints");
heatflow_deltaT = get_param(heatFlow, "deltaT");

heatflowSignal = SignalDesigner("continuous");
heatflowSignal.XYData = heatflow_dataPoints;
heatflowSignal.DeltaX = heatflow_deltaT;

plotDataPoints(currSignal);
% plotDataPoints(heatflowSignal);

%{
% Get timetable objects.
LoadCurr_tt = inSigs.LoadCurrent;

if nvpairs.Visible
  fig = figure;
else
  fig = figure(Visible='off');
end

if nvpairs.WindowName ~= ""
  fig.Name = nvpairs.WindowName;
end

% Adjust the figure position in the screen.
pos = fig.Position;
origHeight = pos(4);
figWidth = nvpairs.Width;
figHeight = nvpairs.Height;
fig.Position = [pos(1), pos(2)-(figHeight-origHeight), figWidth, figHeight];

tlayout = tiledlayout(1, 1);
tlayout.TileSpacing = "compact";
tlayout.Padding = "compact";
tlayout.TileIndexing = "columnmajor";

tl_1 = nexttile;
makePlot(tl_1, LoadCurr_tt, LoadCurr_tt.Time, LoadCurr_tt.LoadCurrent, 2)

% tl_2 = nexttile;
% makePlot(tl_2, BrkF_tt, BrkF_tt.Time, BrkF_tt.BrakeForce, 2)

% linkaxes([tl_1 tl_2 tl_3], "x")

end  % function

function makePlot(parent, timetbl_obj, t, y, threshold_value)

varNameStr = @(tt) string(tt.Properties.VariableNames);
unitStr = @(tt) "(" + string(tt.Properties.VariableUnits) + ")";

plot(parent, t, y, LineWidth=2)
hold on
grid on
xlim([t(1) t(end)])
setMinimumYRange( ...
  gca, ...
  y, ...
  dy_threshold = threshold_value );
ylabel(unitStr(timetbl_obj))
title(varNameStr(timetbl_obj), Interpreter="none")

%}

end  % function
