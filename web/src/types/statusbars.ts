export interface HealthBarProps {
  value: number;
  isLow: boolean;
  isDead: boolean;
  icon?: string;
  deadIcon?: string;
}

export interface StaminaBarProps {
  value: number;
  icon?: string;
}

export interface FoodBarProps {
  value: number;
  icon?: string;
}

export interface WaterBarProps {
  value: number;
  icon?: string;
}

export interface StressBarProps {
  value: number;
  icon?: string;
}

export interface OxygenFillProps {
  oxygen: number;
}