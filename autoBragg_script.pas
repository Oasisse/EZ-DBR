const
  numberLayers = 10;            // number of Bragg layers
  n_points = 5;                  // number of points to consider for turning point detection
  filename = 'optimallambdas.csv';
  time_min_layer = 240;          // minimum time (s) to detect a turning point (500nm/h ~ 238s)

Var
  Ok: boolean;
  i, j, y, n, l, H_index: integer;
  lambda, intensity: real;
  res: array[1..numberLayers] of real;
  int_array: array[1..n_points] of real;
  TP: boolean;

Begin
////////// Reading optimalLambdas file ///////////
  ok := Fopen(1, filename, fm_Read);
  n := numberLayers*2 + 2;
  l := 0;
  if ok then
  Begin
    for i := 0 to n-1 do
    Begin
      if i > 1 then
      begin
        // Reads each wavelength value from the .csv and stores them in res[]
        if i mod 2 <> 0 then
        begin
          lambda := FLoadValue(1) * 1000.0;
          res[l] := lambda;
        end
        else
        begin
          l := FLoadValue(1);
        end;
      end
      else
        FLoadValue(1);
    end;
  End
  else
    ShowMessage('Error reading the file');
  Fclose(1);

  ShowValue('Number of layers detected:', l); // prints that the layers are correctly detected

////////// Start of real-time control ///////////
n := 0;
Growth.EZ_CREW.EZ_REF.Optimal_Lambda_StartStop := True;
H_index := 1;
Growth.Ga6_ABN300DF.shutter.Control := 0;    // start AlAs
Growth.Al5_ABN150DF.shutter.Control := 1;

for i := 1 to numberLayers do
Begin  // Start of setlambda for each layer
  Growth.EZ_CREW.EZ_REF.Optimal_Lambda := res[i];  // Set optimal lambda for layer i

  if H_index = 1 then
  begin
    for y := 1 to n_points do
      int_array[y] := 5000;
  end
  else
    for y := 1 to n_points do
      int_array[y] := 0;

  TP := false;
  ResetTimer(2); // Reset timer for minimum layer time

  Repeat

    // Freeze
    ResetTimer(1);
    Repeat until GetTimer(1) > 5;  // Freeze the program for 5 seconds between each measurement

    // Measurement
    intensity := Growth.EZ_CREW.EZ_REF.Optimal_Lambda_Intensity;  // measure intensity at optimal lambda
    Recipe.log(true, 'Optimal lambda n°' + IntToStr(i) + ' = ' + RealToStr(res[i], 3) + ' Intensity = ' + RealToStr(intensity, 2));

    for j := 1 to n_points-1 do
    begin  // update values of detection points for turning point
      int_array[j] := int_array[j+1];
    end;
    int_array[n_points] := intensity;  // the last value of int_array is the last read value

    // Turning point detection
    if GetTimer(2) > time_min_layer then
    Begin  // check if the time since the last turning point is greater than time_min_layer
      TP := true;
      if H_index = 1 then
      begin  // high refractive index material (e.g., AlAs)
        for j := 1 to n_points-1 do
        begin
          if intensity <= int_array[j] then
            TP := false;  // TP remains true if the measurement is greater than the last 5 measurements. Otherwise, TP = false
        end;
      end
      else
      begin  // low refractive index material (e.g., GaAs)
        for j := 1 to n_points-1 do
        begin
          if intensity >= int_array[j] then
            TP := false;  // TP remains true if the measurement is less than the last 5 measurements. Otherwise, TP = false
        end;
      end;
    End;

    // Layer change
    if TP then
    begin  // TP is the turning point condition
      if i = numberLayers then
      begin
        Growth.Ga6_ABN300DF.shutter.Control := 0;
        Growth.Al5_ABN150DF.shutter.Control := 0;
        Layer('End script', 1000);
      end
      else if Growth.Ga6_ABN300DF.shutter.Control = 1 then
      begin
        Growth.Ga6_ABN300DF.shutter.Control := 0;
        Growth.Al5_ABN150DF.shutter.Control := 1;
        H_index := 1;
        Layer('AlAs', 2000); // wait
      end
      else
      begin
        Growth.Al5_ABN150DF.shutter.Control := 0;
        Growth.Ga6_ABN300DF.shutter.Control := 1;
        H_index := 0;
        Layer('GaAs', 1000); // wait
      end;
    end;

  until TP;
End;

Growth.Ga6_ABN300DF.shutter.Control := 0;
Growth.Al5_ABN150DF.shutter.Control := 0;
Growth.EZ_CREW.EZ_REF.Optimal_Lambda_StartStop := false;
End.
