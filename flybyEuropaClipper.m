%% Spacecraft - Europa Clippper Trajectory

%% Pre-Launch

    muE = 398600;
    muS=1.327e11;          %Gravitational parameter for Sun
    aE = 149.6e6;          % Distance from Earth to Sun
    aM = 227.9e6;          % Distance from Mars to Sun 
    aJ = 778.6e6;          % Distance from Jupiter to Sun
    deltaVsc = sqrt((2*muS/aE) - (2*muS/(aE+aM))) - sqrt(muS/aE) % = 

    % CAN WE ASSUME WE'RE DOING HOHMANN AT PERIAPSIS AND APOAPSIS??
    maxDays0= (pi/sqrt(muS))*sqrt(((ae+aj)/2)^3)/(3600*24)
    maxDays=300;         % Number of days to follow the spaceraft = t12
                         % for Earth-Mars flyby
    fbday1 = 105;        % ???

    rsc=zeros(maxDays,3); % Position vector array for spacecraft
    vsc=zeros(maxDays,3); % Velocity vector array for spacecraft

            
    finalDate=initialDate+days(maxDays); %date when sc stops appearing in simulation
    launchDay=15; % # of days to launch from Start Date

    tinit=datetime(initialDate); % initial time as datetime variable type

    % Curtis function:
     for dayCount=1:launchDay
    t=tinit+days(dayCount-1); % index dayCount=1 corresponds to initial time.
    [y,m,d]=ymd(t);           % year month day format of current time

    % Use planet_elements_and_sv_coplanar to find current position and
    % velocity

    [~, r, v, ~] =planet_elements_and_sv_coplanar ...
    (1.327e11, 3, y, m, d, 0, 0, 0);

    % Update the position and velocity vectors
    rsc(dayCount,:)=[r(1),r(2),0];
    vsc(dayCount,:)=[v(1), v(2),0];
    end


%% Departure from Earth

t=tinit+days(launchDay);
    [y,m,d]=ymd(t);
    [coe, R, V, jd] =planet_elements_and_sv_coplanar ...
    (1.327e11, 3, y, m, d, 0, 0, 0);

    Vsc = V - 4*V/norm(V); %Delta v is -4km/s
   

    % Calculate the orbital elements for spacecraft
   [h,a,e,w,E0]=scElements(R,Vsc);

    % propagate the new orbit for spacecraft 
   [rsc,vsc]=propagate(h,a,e,w,E0,launchDay+1,fbday1,rsc,vsc);


%% Mars Flyby

% Call flyby [Vout,DeltaMin]=flyby(Vp,Vsc,Delta,mu,rp,ccw)

%% Earth Flyby

%% Arrival at Jupiter