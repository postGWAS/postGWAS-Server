import router from '../router';

export default function navigateToResult(jobID) {
    // console.log(jobID);
    router.push({
        path: '/result',
        query: {
            jobId: jobID,
            date: new Date().getTime()
        }
    });
}