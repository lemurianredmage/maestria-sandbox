import Header from "@components/layout/header";
import Main from "@components/layout/main";
import Footer from "@components/layout/footer";

export default function Home() {
	return (
		<div className="flex flex-col min-h-screen">
			<Header />
			<Main />
			<Footer />
		</div>
	);
}
