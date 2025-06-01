function [isInEllipse,xEllipseRot, yEllipseRot] = func_checkPlotINEllipse(x, y, a, b, xc, yc, theta)


   
    xRot = (x - xc) * cos(theta) + (y - yc) * sin(theta);
    yRot = (y - yc) * cos(theta) - (x - xc) * sin(theta);

    if (xRot^2/a^2 + yRot^2/b^2) <= 1
        isInEllipse = true;
    else
        isInEllipse = false;
    end

    phi = linspace(0, 2*pi, 100);
    xEllipse = a * cos(phi);
    yEllipse = b * sin(phi);

    xEllipseRot = xEllipse * cos(theta) - yEllipse * sin(theta);
    yEllipseRot = xEllipse * sin(theta) + yEllipse * cos(theta);

    xEllipseRot = xEllipseRot + xc;
    yEllipseRot = yEllipseRot + yc;

end