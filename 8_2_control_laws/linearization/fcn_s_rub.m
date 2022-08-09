function [s_rub] = fcn_s_rub(in_rub)
    %% in_rlb sorting
    z_r = in_rub(1:2,1);
    l_r = in_rub(3,1);
    z_ub = in_rub(4:9,1);
    h_ub = in_rub(10,1);
    w_ub = in_rub(11,1);
    Fi_b_z = in_rub(12,1);
    s_r_try = in_rub(13:18,1);
    
    %% calculation
    fcn = @(s_r) F_ub(s_r,z_r,l_r,z_ub,h_ub,w_ub,Fi_b_z);
    s_rub = fsolve(fcn,s_r_try')';
    
    %% function definition
    function F = F_ub(s_r,z_r,l_r,z_ub,h_ub,w_ub,Fi_b_z)
    % T_F(1,1:4)
        F(1) = cos(s_r(5))*cos(s_r(6))+sin(z_r(2))*(cos(z_r(1))*sin(z_ub(5))+sin(z_r(1))*(cos(Fi_b_z)*cos(z_ub(5))*sin(z_ub(6))+sin(Fi_b_z)*cos(z_ub(5))*cos(z_ub(6))))-cos(z_r(2))*(cos(Fi_b_z)*cos(z_ub(5))*cos(z_ub(6))-sin(Fi_b_z)*cos(z_ub(5))*sin(z_ub(6)));
        F(2) = cos(z_r(1))*(cos(Fi_b_z)*cos(z_ub(5))*sin(z_ub(6))+sin(Fi_b_z)*cos(z_ub(5))*cos(z_ub(6)))-sin(z_r(1))*sin(z_ub(5))-cos(s_r(5))*sin(s_r(6));
        F(3) = sin(s_r(5))-cos(z_r(2))*(cos(z_r(1))*sin(z_ub(5))+sin(z_r(1))*(cos(Fi_b_z)*cos(z_ub(5))*sin(z_ub(6))+sin(Fi_b_z)*cos(z_ub(5))*cos(z_ub(6))))-sin(z_r(2))*(cos(Fi_b_z)*cos(z_ub(5))*cos(z_ub(6))-sin(Fi_b_z)*cos(z_ub(5))*sin(z_ub(6)));
        F(4) = s_r(1)-z_ub(1)+h_ub*sin(z_ub(5))+(w_ub*sin(Fi_b_z+z_ub(6))*cos(z_ub(5)))/2+(l_r*cos(Fi_b_z+z_ub(6))*cos(z_ub(5))*sin(z_r(2)))/2+(l_r*cos(z_r(1))*cos(z_r(2))*sin(z_ub(5)))/2+(l_r*cos(Fi_b_z)*cos(z_r(2))*cos(z_ub(5))*sin(z_r(1))*sin(z_ub(6)))/2+(l_r*sin(Fi_b_z)*cos(z_r(2))*cos(z_ub(5))*cos(z_ub(6))*sin(z_r(1)))/2;
        % T_F(2,1:4)
        F(5) = cos(s_r(4))*sin(s_r(6))-cos(z_r(2))*(cos(Fi_b_z)*(cos(z_ub(4))*sin(z_ub(6))+cos(z_ub(6))*sin(z_ub(4))*sin(z_ub(5)))+sin(Fi_b_z)*(cos(z_ub(4))*cos(z_ub(6))-sin(z_ub(4))*sin(z_ub(5))*sin(z_ub(6))))-sin(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(z_ub(4))*cos(z_ub(6))-sin(z_ub(4))*sin(z_ub(5))*sin(z_ub(6)))-sin(Fi_b_z)*(cos(z_ub(4))*sin(z_ub(6))+cos(z_ub(6))*sin(z_ub(4))*sin(z_ub(5))))+cos(z_r(1))*cos(z_ub(5))*sin(z_ub(4)))+cos(s_r(6))*sin(s_r(4))*sin(s_r(5));
        F(6) = cos(s_r(4))*cos(s_r(6))-cos(z_r(1))*(cos(Fi_b_z)*(cos(z_ub(4))*cos(z_ub(6))-sin(z_ub(4))*sin(z_ub(5))*sin(z_ub(6)))-sin(Fi_b_z)*(cos(z_ub(4))*sin(z_ub(6))+cos(z_ub(6))*sin(z_ub(4))*sin(z_ub(5))))-sin(s_r(4))*sin(s_r(5))*sin(s_r(6))+cos(z_ub(5))*sin(z_r(1))*sin(z_ub(4));
        F(7) = cos(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(z_ub(4))*cos(z_ub(6))-sin(z_ub(4))*sin(z_ub(5))*sin(z_ub(6)))-sin(Fi_b_z)*(cos(z_ub(4))*sin(z_ub(6))+cos(z_ub(6))*sin(z_ub(4))*sin(z_ub(5))))+cos(z_r(1))*cos(z_ub(5))*sin(z_ub(4)))-cos(s_r(5))*sin(s_r(4))-sin(z_r(2))*(cos(Fi_b_z)*(cos(z_ub(4))*sin(z_ub(6))+cos(z_ub(6))*sin(z_ub(4))*sin(z_ub(5)))+sin(Fi_b_z)*(cos(z_ub(4))*cos(z_ub(6))-sin(z_ub(4))*sin(z_ub(5))*sin(z_ub(6))));
        F(8) = s_r(2)-z_ub(2)-(w_ub*(cos(Fi_b_z)*(cos(z_ub(4))*cos(z_ub(6))-sin(z_ub(4))*sin(z_ub(5))*sin(z_ub(6)))-sin(Fi_b_z)*(cos(z_ub(4))*sin(z_ub(6))+cos(z_ub(6))*sin(z_ub(4))*sin(z_ub(5)))))/2+(l_r*(sin(z_r(2))*(cos(Fi_b_z)*(cos(z_ub(4))*sin(z_ub(6))+cos(z_ub(6))*sin(z_ub(4))*sin(z_ub(5)))+sin(Fi_b_z)*(cos(z_ub(4))*cos(z_ub(6))-sin(z_ub(4))*sin(z_ub(5))*sin(z_ub(6))))-cos(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(z_ub(4))*cos(z_ub(6))-sin(z_ub(4))*sin(z_ub(5))*sin(z_ub(6)))-sin(Fi_b_z)*(cos(z_ub(4))*sin(z_ub(6))+cos(z_ub(6))*sin(z_ub(4))*sin(z_ub(5))))+cos(z_r(1))*cos(z_ub(5))*sin(z_ub(4)))))/2-h_ub*cos(z_ub(5))*sin(z_ub(4));
        % T_F(3,1:4)
        F(9) = sin(s_r(4))*sin(s_r(6))-cos(z_r(2))*(cos(Fi_b_z)*(sin(z_ub(4))*sin(z_ub(6))-cos(z_ub(4))*cos(z_ub(6))*sin(z_ub(5)))+sin(Fi_b_z)*(cos(z_ub(6))*sin(z_ub(4))+cos(z_ub(4))*sin(z_ub(5))*sin(z_ub(6))))-sin(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(z_ub(6))*sin(z_ub(4))+cos(z_ub(4))*sin(z_ub(5))*sin(z_ub(6)))-sin(Fi_b_z)*(sin(z_ub(4))*sin(z_ub(6))-cos(z_ub(4))*cos(z_ub(6))*sin(z_ub(5))))-cos(z_r(1))*cos(z_ub(4))*cos(z_ub(5)))-cos(s_r(4))*cos(s_r(6))*sin(s_r(5));
        F(10) = cos(s_r(6))*sin(s_r(4))-cos(z_r(1))*(cos(Fi_b_z)*(cos(z_ub(6))*sin(z_ub(4))+cos(z_ub(4))*sin(z_ub(5))*sin(z_ub(6)))-sin(Fi_b_z)*(sin(z_ub(4))*sin(z_ub(6))-cos(z_ub(4))*cos(z_ub(6))*sin(z_ub(5))))+cos(s_r(4))*sin(s_r(5))*sin(s_r(6))-cos(z_ub(4))*cos(z_ub(5))*sin(z_r(1));
        F(11) = cos(s_r(4))*cos(s_r(5))-sin(z_r(2))*(cos(Fi_b_z)*(sin(z_ub(4))*sin(z_ub(6))-cos(z_ub(4))*cos(z_ub(6))*sin(z_ub(5)))+sin(Fi_b_z)*(cos(z_ub(6))*sin(z_ub(4))+cos(z_ub(4))*sin(z_ub(5))*sin(z_ub(6))))+cos(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(z_ub(6))*sin(z_ub(4))+cos(z_ub(4))*sin(z_ub(5))*sin(z_ub(6)))-sin(Fi_b_z)*(sin(z_ub(4))*sin(z_ub(6))-cos(z_ub(4))*cos(z_ub(6))*sin(z_ub(5))))-cos(z_r(1))*cos(z_ub(4))*cos(z_ub(5)));
        F(12) = s_r(3)-z_ub(3)-(w_ub*(cos(Fi_b_z)*(cos(z_ub(6))*sin(z_ub(4))+cos(z_ub(4))*sin(z_ub(5))*sin(z_ub(6)))-sin(Fi_b_z)*(sin(z_ub(4))*sin(z_ub(6))-cos(z_ub(4))*cos(z_ub(6))*sin(z_ub(5)))))/2+(l_r*(sin(z_r(2))*(cos(Fi_b_z)*(sin(z_ub(4))*sin(z_ub(6))-cos(z_ub(4))*cos(z_ub(6))*sin(z_ub(5)))+sin(Fi_b_z)*(cos(z_ub(6))*sin(z_ub(4))+cos(z_ub(4))*sin(z_ub(5))*sin(z_ub(6))))-cos(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(z_ub(6))*sin(z_ub(4))+cos(z_ub(4))*sin(z_ub(5))*sin(z_ub(6)))-sin(Fi_b_z)*(sin(z_ub(4))*sin(z_ub(6))-cos(z_ub(4))*cos(z_ub(6))*sin(z_ub(5))))-cos(z_r(1))*cos(z_ub(4))*cos(z_ub(5)))))/2+h_ub*cos(z_ub(4))*cos(z_ub(5));
    end
end