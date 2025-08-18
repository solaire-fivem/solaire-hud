export interface VehicleSpeedDisplayProps {
  speed: number;
  unit?: 'MPH' | 'KM/H';
  inVehicle?: boolean;
}

export interface SeatbeltIconProps {
  isSeatbeltOn: boolean;
  className?: string;
  icon?: string;
}

export interface FuelIconProps {
  fuelLevel: number;
  icon?: string;
}