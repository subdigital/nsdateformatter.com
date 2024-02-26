import config from "./config.js";

export const initialData = {
  inputData: "",
  locales: [],
  defaultLocale: "",
  examples: [],
  exampleFormat: "",
  exampleResult: "", 
};

export const fetchData = async () => {
  try {
    const response = await fetch(`${config.backendUrl}/viewData`);
    const data = await response.json();
    console.log(data);
    return data;
  } catch (error) {
    console.error(error);
  }
}

