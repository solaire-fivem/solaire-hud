import React, { useEffect, useRef, useState } from "react";
import { OxygenFillProps } from "../../types/statusbars";

const OxygenFill: React.FC<OxygenFillProps> = ({ oxygen }) => {
  const safeOxygen = Math.max(0, Math.min(oxygen, 100));
  const targetFill = Math.max(0, Math.min(1, 1 - safeOxygen / 100));
  const [fillPercent, setFillPercent] = useState(targetFill);
  const rafRef = useRef<number>();

  useEffect(() => {
    function animate() {
      setFillPercent((prev) => {
        if (Math.abs(prev - targetFill) < 0.005) return targetFill;
        return prev + (targetFill - prev) * 0.08;
      });
      if (Math.abs(fillPercent - targetFill) >= 0.005) {
        rafRef.current = requestAnimationFrame(animate);
      }
    }
    rafRef.current && cancelAnimationFrame(rafRef.current);
    if (Math.abs(fillPercent - targetFill) >= 0.005) {
      rafRef.current = requestAnimationFrame(animate);
    } else {
      setFillPercent(targetFill);
    }
    return () => {
      if (rafRef.current) {
        cancelAnimationFrame(rafRef.current);
      }
    };
  }, [targetFill]);

  if (safeOxygen >= 100) return null;
  return (
    <svg
      className="absolute top-0 left-0 pointer-events-none"
      width={96}
      height={96}
      viewBox="0 0 96 96"
    >
      <defs>
        <clipPath id="mugshot-circle">
          <circle cx="48" cy="48" r="48" />
        </clipPath>
      </defs>
      <g clipPath="url(#mugshot-circle)">
        <g>
          <path
            id="wave"
            fill="#2a8fbbff"
            fillOpacity="0.6"
            d={`
              M0,${96 - 96 * fillPercent}
              Q24,${96 - 96 * fillPercent - 8} 48,${96 - 96 * fillPercent}
              T96,${96 - 96 * fillPercent}
              V96 H0 Z
            `}
          >
            <animate
              attributeName="d"
              dur="2s"
              repeatCount="indefinite"
              values={`
                M0,${96 - 96 * fillPercent}
                Q24,${96 - 96 * fillPercent - 8} 48,${96 - 96 * fillPercent}
                T96,${96 - 96 * fillPercent}
                V96 H0 Z;
                M0,${96 - 96 * fillPercent}
                Q24,${96 - 96 * fillPercent + 8} 48,${96 - 96 * fillPercent}
                T96,${96 - 96 * fillPercent}
                V96 H0 Z;
                M0,${96 - 96 * fillPercent}
                Q24,${96 - 96 * fillPercent - 8} 48,${96 - 96 * fillPercent}
                T96,${96 - 96 * fillPercent}
                V96 H0 Z
              `}
            />
          </path>
        </g>
      </g>
    </svg>
  );
};

export default OxygenFill;
