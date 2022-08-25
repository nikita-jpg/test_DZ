async function main() {
  const { default: imagemin } = await import("imagemin");
  const { default: webp } = await import("imagemin-webp");
  const path = require("path");

  const IMAGES_DIR = path.resolve(__dirname, "..", "src", "assets");

  console.log(`Build images at: ${IMAGES_DIR}`);

  await imagemin([path.join(IMAGES_DIR, "*.{jpg,png}")], {
    destination: IMAGES_DIR,
    plugins: [webp({ quality: 60 })],
  });

  console.log("Built successfully");
}

main();
