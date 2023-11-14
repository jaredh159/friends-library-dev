import AdminClient, { type T } from '@friends-library/pairql/admin';

export default AdminClient.web(
  window.location.href,
  () => localStorage.getItem(`token`) ?? undefined,
);

export { T };
