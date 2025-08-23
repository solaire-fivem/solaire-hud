import React, { useState, useRef, useEffect } from 'react';
import { DraggableComponentProps, Position } from '../../types/hudeditor';
import { fetchNui } from '../../utils/fetchNui';

const DraggableComponent: React.FC<DraggableComponentProps> = ({
  children,
  componentId,
  editMode,
  initialPosition = { x: 0, y: 0 },
  onPositionChange,
  style = {}
}) => {
  const [position, setPosition] = useState<Position>(initialPosition);
  const [isDragging, setIsDragging] = useState(false);
  const [dragStart, setDragStart] = useState<Position>({ x: 0, y: 0 });
  const [dragOffset, setDragOffset] = useState<Position>({ x: 0, y: 0 });
  const elementRef = useRef<HTMLDivElement>(null);
  const lastUpdateRef = useRef<number>(0);

  useEffect(() => {
    setPosition(initialPosition);
  }, [initialPosition]);

  const handleMouseDown = (e: React.MouseEvent) => {
    if (!editMode) return;
    
    e.preventDefault();
    e.stopPropagation();
    
    const rect = elementRef.current?.getBoundingClientRect();
    if (!rect) return;

    setIsDragging(true);
    setDragStart({ x: e.clientX, y: e.clientY });
    setDragOffset({
      x: e.clientX - rect.left,
      y: e.clientY - rect.top
    });
  };

  const handleMouseMove = (e: MouseEvent) => {
    if (!isDragging || !editMode) return;

    const newPosition = {
      x: e.clientX - dragOffset.x,
      y: e.clientY - dragOffset.y
    };

    setPosition(newPosition);
  };

  const handleMouseUp = () => {
    if (!isDragging) return;
    
    setIsDragging(false);
    onPositionChange(componentId, position);
  };

  useEffect(() => {
    if (isDragging) {
      document.addEventListener('mousemove', handleMouseMove);
      document.addEventListener('mouseup', handleMouseUp);
    }

    return () => {
      document.removeEventListener('mousemove', handleMouseMove);
      document.removeEventListener('mouseup', handleMouseUp);
    };
  }, [isDragging, dragOffset, position]);

  return (
    <div
      ref={elementRef}
      style={{
        position: 'absolute',
        left: `${position.x}px`,
        top: `${position.y}px`,
        ...style
      }}
      className={[
        editMode ? 'border-2 border-dashed border-[#ab8e2c] rounded p-1 bg-[#ab8e2c1a] shadow-md transition-none select-none' : '',
        isDragging ? 'z-[9999] cursor-grabbing outline outline-2 outline-[#ab8e2c]' : '',
        editMode && !isDragging ? 'cursor-grab z-[1000]' : '',
        !editMode ? 'cursor-default transition-all duration-200' : ''
      ].join(' ')}
      onMouseDown={handleMouseDown}
    >
      {editMode && (
        <div className="absolute -top-6 left-0 bg-[#ab8e2c] text-white px-2 py-0.5 rounded text-xs font-cinzel whitespace-nowrap z-[10000]">
          {componentId}
        </div>
      )}
      {children}
    </div>
  );
};

export default DraggableComponent;
