import { useState, useCallback } from 'react';
import { Position, HudPositions } from '../types/hudeditor';
import { fetchNui } from '../utils/fetchNui';

const getDefaultPositions = (): HudPositions => ({
  playerHud: { x: 0, y: 0 },
  speedometer: { x: window.innerWidth - 180, y: window.innerHeight - 180 }
});

export const useHudPositions = () => {
  const [positions, setPositions] = useState<HudPositions>(getDefaultPositions());

  const updatePosition = useCallback((componentId: string, position: Position) => {
    setPositions(prev => {
      const newPositions = {
        ...prev,
        [componentId]: position
      };
      
      fetchNui('savePositions', newPositions);
      
      return newPositions;
    });
  }, []);

  const loadPositions = useCallback((newPositions: HudPositions) => {
    setPositions(prev => ({
      ...prev,
      ...newPositions
    }));
  }, []);

  const resetPositions = useCallback(() => {
    const resetPositions = getDefaultPositions();
    
    setPositions(resetPositions);
    fetchNui('savePositions', resetPositions);
  }, []);

  return {
    positions,
    updatePosition,
    loadPositions,
    resetPositions
  };
};
