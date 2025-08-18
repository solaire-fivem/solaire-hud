export interface ArmorIconProps {
  armor: number;
  className?: string;
}

export interface MugshotProps {
  mugshot: string | null;
}

export interface PlayerStats {
  health: number;
  stamina: number;
  hunger: number;
  thirst: number;
  stress: number;
}