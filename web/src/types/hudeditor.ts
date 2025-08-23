export interface Position {
  x: number;
  y: number;
}

export interface HudPositions {
  playerHud?: Position;
  speedometer?: Position;
}

export interface EditModeData {
  editMode: boolean;
}

export interface DraggableComponentProps {
  children: React.ReactNode;
  componentId: string;
  editMode: boolean;
  initialPosition?: Position;
  onPositionChange: (componentId: string, position: Position) => void;
  style?: React.CSSProperties;
}
