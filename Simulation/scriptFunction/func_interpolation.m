function spline_y=func_interpolation(ts_x,ts_y)

    fine_x = linspace(min(ts_x), max(ts_x), 200);
    
    spline_y = interp1(ts_x, ts_y, fine_x, 'spline');

end