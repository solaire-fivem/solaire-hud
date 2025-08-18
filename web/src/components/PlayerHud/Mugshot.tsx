import React from "react";
import { MugshotProps } from "../../types/playerhud";

const Mugshot: React.FC<MugshotProps> = ({ mugshot }) => (
  <div
    className="mt-8 w-24 h-24 bg-gray-900 bg-opacity-90 rounded-full overflow-hidden shadow-lg"
    style={{
      boxShadow: "0 0 2px 2px #ab8e2cff, 0 0 8px 2px #ab8e2c88, 0 0 8px 1px #111827",
    }}
  >
    {mugshot ? (
      <img src={mugshot.trim()} className="w-full h-full object-cover" alt="Player Portrait" />
    ) : (
      <div className="w-full h-full bg-gray-700"></div>
    )}
  </div>
);

export default Mugshot;