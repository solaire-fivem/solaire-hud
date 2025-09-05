import React from 'react';
import { fetchNui } from '../../utils/fetchNui';

interface EditModeOverlayProps {
  isVisible: boolean;
}

const EditModeOverlay: React.FC<EditModeOverlayProps> = ({ isVisible }) => {
  if (!isVisible) return null;

  const handleSaveAndExit = () => {
    fetchNui('closeEditMode');
  };

  return (
    <div className="fixed mt-8 right-5 z-[10000] bg-gray-900 border-2 border-[#ab8e2c] rounded-lg p-4 text-white font-cinzel shadow-lg opacity-85 shadow-[#ab8e2c80]">
      <h3 className="m-0 mb-3 text-[#ab8e2c] text-2xl font-bold">
        Edit Mode
      </h3>
      <p className="m-0 mb-4 text-md leading-relaxed">
        Drag components to reposition them.<br />
        Changes are saved automatically.
      </p>
      <div className="flex gap-2">
        <button
          onClick={handleSaveAndExit}
          className="bg-[#ab8e2c] hover:bg-[#8b7324] text-white font-bold rounded px-4 py-2 cursor-pointer font-cinzel text-md transition-all"
        >
          Save Configuration
        </button>
      </div>
    </div>
  );
};

export default EditModeOverlay;
