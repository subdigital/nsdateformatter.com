import config from "./config.js";

export const initialData = {
  inputDate: "",
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
    return data;
  } catch (error) {
    console.error(error);
  }
}

/** 
 * @param {Object} req
 * @param {string} req.locale 
 * @param {number} req.timestamp 
 * @param {Object} req.format 
 * @param {string} [req.format.date] - full, long, medium, short
 * @param {string} [req.format.time] - full, long, medium, short
 * @param {string} [req.format.template]
 * @param {string} [req.format.raw]
 */
export const formatDate = async (req) => {
  try {
    const response = await fetch(`${config.backendUrl}/api/format`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify([req]),
    })
    return await response.json();
  } catch(error) {
    console.error(error);
  }
}
