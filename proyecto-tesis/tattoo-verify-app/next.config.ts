import type { NextConfig } from "next";
import path from "path";

const nextConfig: NextConfig = {
	webpack: (config) => {
		config.resolve.alias = {
			...config.resolve.alias,
			"@components": path.resolve(__dirname, "src/app/components"),
		};
		return config;
	},
};

export default nextConfig;
